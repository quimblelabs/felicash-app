import 'dart:async';

import 'package:flutter/material.dart';

/// Defines the breaks of the text.
enum TextBreaks {
  /// The text will be broken by characters.
  ///
  /// eg: `Hello World` -> `H`, `e`, `l`, `l`, `o`, ` `, `W`, `o`, `r`, `l`, `d`
  character,

  /// The text will be broken by words.
  ///
  /// eg: `Hello World` -> `Hello`, `World`
  word,
}

/// A widget that builds a text from a stream of strings.
///
/// - `context` - The build context.
/// - `text` - The text that will be built.
/// - `textUntilNow` - The text that has been built until now.
typedef TextStreamingBuilder = Widget Function(
  BuildContext context,
  String text,
  String textUntilNow,
);

/// {@template text_streaming_builder}
/// A widget that builds a text from a stream of strings.
///
/// Turn the [input] into a [Stream<String>], and build a text from it.
///
/// This is useful to build a typing text effect.
/// {@endtemplate}
class TextStreamBuilder extends StatefulWidget {
  /// {@macro text_streaming_builder}
  const TextStreamBuilder({
    required this.input,
    required this.builder,
    this.duration,
    this.delay,
    this.breaks = TextBreaks.character,
    this.onComplete,
    super.key,
  })  : assert(
          duration != null || delay != null,
          'Either duration or delay must be specified',
        ),
        assert(
          duration == null || delay == null,
          'Can not use both duration and delay',
        );

  /// The input to build the text from.
  final String input;

  /// The duration of the typing effect.
  ///
  /// Use [duration] and [delay] to control the typing effect.
  ///
  /// If [delay] is not specified, the [duration] will be
  /// divided by the number of characters.
  ///
  /// Can not be use with [delay].
  final Duration? duration;

  /// Each delay between each break.
  ///
  /// If not specified, the [duration] will be
  /// divided by the number of characters.
  final Duration? delay;

  /// The type of the breaks that will be applied to the text stream.
  final TextBreaks breaks;

  /// The builder that will be used to build the text.
  final TextStreamingBuilder builder;

  /// The callback that will be called when the text is fully built.
  final VoidCallback? onComplete;

  @override
  State<TextStreamBuilder> createState() => _TextStreamBuilderState();
}

class _TextStreamBuilderState extends State<TextStreamBuilder> {
  late StreamController<({String text, String untilNow})> _controller;
  late Stream<({String text, String untilNow})> _stream;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  void _initializeController() {
    _controller = StreamController<({String text, String untilNow})>();
    _stream = _controller.stream;
    _isInitialized = true;
    _startStreaming();
  }

  @override
  void didUpdateWidget(TextStreamBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isInitialized) return;
    if (widget.input != oldWidget.input ||
        widget.duration != oldWidget.duration ||
        widget.delay != oldWidget.delay ||
        widget.breaks != oldWidget.breaks) {
      _controller.close();
      _initializeController();
    }
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<({String text, String untilNow})>(
      stream: _stream,
      builder: (context, snapshot) {
        final (:text, :untilNow) = snapshot.data ?? (text: '', untilNow: '');
        return widget.builder(
          context,
          text,
          untilNow,
        );
      },
    );
  }

  Future<void> _startStreaming() async {
    final input = _breakInput();
    final count = input.length;
    final delay = _calculateDelayTime(count);
    final buffer = StringBuffer();
    for (var i = 0; i < count; i++) {
      final text = buffer.toString();
      _controller.add((text: input[i], untilNow: text));
      buffer.write(input[i]);
      await Future<void>.delayed(delay);
    }
    // Add the last text as empty
    _controller.add((text: '', untilNow: buffer.toString()));
    widget.onComplete?.call();
  }

  Duration _calculateDelayTime(int count) {
    if (widget.duration != null) {
      return widget.duration! ~/ count;
    } else {
      return widget.delay!;
    }
  }

  List<String> _breakInput() {
    switch (widget.breaks) {
      case TextBreaks.character:
        return widget.input.split('');
      case TextBreaks.word:
        final breaks = widget.input.split(' ');
        //Re-add the spaces
        for (var i = 1; i < breaks.length; i++) {
          breaks[i] = ' ${breaks[i]}';
        }
        return breaks;
    }
  }
}
