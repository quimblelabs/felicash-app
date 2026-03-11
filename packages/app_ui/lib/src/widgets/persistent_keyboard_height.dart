import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

/// A widget that provides keyboard height information to its descendants.
class KeyboardHeight extends InheritedWidget {
  /// Creates a [KeyboardHeight] widget.
  const KeyboardHeight({
    required this.height,
    required super.child,
    super.key,
  });

  /// The current keyboard height.
  final double height;

  /// Returns the current keyboard height from the closest [KeyboardHeight]
  /// instance that encloses the given context.
  static double of(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<KeyboardHeight>();
    assert(
      widget != null,
      'No KeyboardHeight found in context',
    );
    return widget!.height;
  }

  @override
  bool updateShouldNotify(KeyboardHeight oldWidget) {
    return oldWidget.height != height;
  }
}

/// A widget that listens to keyboard height changes and provides the height
/// to its descendants through [KeyboardHeight].
class KeyboardHeightProvider extends StatefulWidget {
  /// Creates a [KeyboardHeightProvider] widget.
  const KeyboardHeightProvider({
    required this.child,
    super.key,
  });

  /// The widget below this widget in the tree.
  final Widget child;

  @override
  State<KeyboardHeightProvider> createState() => _KeyboardHeightProviderState();
}

class _KeyboardHeightProviderState extends State<KeyboardHeightProvider> {
  final _keyboardVisibilityController = KeyboardVisibilityController();
  StreamSubscription<bool>? _keyboardSubscription;
  Timer? _debounceTimer;
  bool _isVisible = false;

  /// The last non-zero keyboard height.
  /// Default values are platform-specific: 320.0 for iOS, 300.0 for Android
  late double _lastNonZeroHeight = _defaultHeight;
  double get _defaultHeight =>
      defaultTargetPlatform == TargetPlatform.iOS ? 320.0 : 300.0;

  @override
  void initState() {
    super.initState();
    _keyboardSubscription = _keyboardVisibilityController.onChange
        .listen(_onKeyboardVisibilityChanged);
  }

  @override
  void dispose() {
    _keyboardSubscription?.cancel();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onKeyboardVisibilityChanged(bool visible) {
    if (!mounted) return;
    _isVisible = visible;
    if (!visible) {
      _debounceTimer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build method only needs to return the KeyboardHeight widget
    // All keyboard height logic is now handled in _onKeyboardVisibilityChanged
    final currentHeight = MediaQuery.of(context).viewInsets.bottom;
    if (_isVisible && currentHeight > 0 && currentHeight > _lastNonZeroHeight) {
      _debounceTimer?.cancel();
      _debounceTimer = Timer(const Duration(milliseconds: 100), () {
        if (mounted) {
          setState(() {
            _lastNonZeroHeight = currentHeight;
          });
        }
      });
    }
    return KeyboardHeight(
      height: _lastNonZeroHeight,
      child: widget.child,
    );
  }
}
