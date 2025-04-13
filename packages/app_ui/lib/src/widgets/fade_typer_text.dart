import 'dart:async';

import 'package:flutter/material.dart';

class _WordAnimation {
  _WordAnimation(this.word, this.controller);

  final String word;
  final AnimationController controller;
}

/// {@template fade_typer_text}
/// A widget that displays text with a typing animation and fade effect.
/// Each word appears one by one with a fade transition.
/// {@endtemplate}
class FadeTyperText extends StatefulWidget {
  /// {@macro fade_typer_text}
  const FadeTyperText({
    required this.text,
    this.style,
    this.typingDuration,
    this.wordDelay,
    this.fadeDuration = const Duration(milliseconds: 200),
    this.onComplete,
    this.enabled = true,
    this.autoPlay = true,
    this.startDelay = Duration.zero,
    super.key,
  }) : assert(
          typingDuration == null || wordDelay == null,
          'typingDuration and wordDelay cannot be set at the same time',
        );

  /// The text to be displayed with the typing animation.
  final String text;

  /// The style to apply to the text.
  final TextStyle? style;

  /// The total duration for the entire typing animation.
  /// This is distributed across all characters.
  final Duration? typingDuration;

  /// The delay between each word appearance.
  final Duration? wordDelay;

  /// The duration of the fade-in animation for each character.
  final Duration fadeDuration;

  /// Callback that is called when the typing animation completes.
  final VoidCallback? onComplete;

  /// Whether the typing animation is enabled.
  final bool enabled;

  /// Whether the typing animation should start automatically.
  final bool autoPlay;

  /// The delay before starting the typing animation.
  final Duration startDelay;

  @override
  State<FadeTyperText> createState() => _FadeTyperTextState();
}

class _FadeTyperTextState extends State<FadeTyperText>
    with TickerProviderStateMixin {
  final List<_WordAnimation> _words = [];
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    if (widget.autoPlay && widget.enabled) {
      _startTypingWithDelay();
    }
  }

  @override
  void didUpdateWidget(FadeTyperText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != oldWidget.text) {
      _disposeAnimations();
      _words.clear();
      _startTyping();
    }
  }

  @override
  void dispose() {
    _disposeAnimations();
    super.dispose();
  }

  void _disposeAnimations() {
    for (final word in _words) {
      word.controller.dispose();
    }
  }

  Future<void> _startTypingWithDelay() async {
    if (widget.startDelay.inMilliseconds > 0) {
      await Future<void>.delayed(widget.startDelay);
    }
    await _startTyping();
  }

  Future<void> _startTyping() async {
    if (_isAnimating || !widget.enabled) return;
    _isAnimating = true;

    final words = widget.text.split(' ');
    final wordCount = words.length;
    final delay = widget.wordDelay ??
        (widget.typingDuration != null
            ? widget.typingDuration! ~/ wordCount
            : const Duration(milliseconds: 200));

    for (final word in words) {
      if (!mounted) return;
      final controller = AnimationController(
        vsync: this,
        duration: widget.fadeDuration,
      );
      setState(() {
        _words.add(_WordAnimation('$word ', controller));
      });
      controller.forward().ignore();
      await Future<void>.delayed(delay);
    }

    _isAnimating = false;
    widget.onComplete?.call();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return Text(
        widget.text,
        style: widget.style,
      );
    }

    return Text.rich(
      TextSpan(
        children: [
          for (final word in _words)
            WidgetSpan(
              child: FadeTransition(
                opacity: word.controller,
                child: Text(
                  word.word,
                  style: widget.style,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
