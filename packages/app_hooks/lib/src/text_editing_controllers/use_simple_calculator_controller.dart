import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// A hook that provides a simple calculator text editing controller
///
/// This hook creates and manages a [SimpleCalculatorTextEditingController] with
/// currency calculation capabilities.
SimpleCalculatorTextEditingController useSimpleCalculatorController([
  double initialValue = 0,
]) {
  return use(
    _SimpleCalculatorEditingControllerHook(initialValue: initialValue),
  );
}

class _SimpleCalculatorEditingControllerHook
    extends Hook<SimpleCalculatorTextEditingController> {
  const _SimpleCalculatorEditingControllerHook({required this.initialValue});

  final double initialValue;

  @override
  _SimpleTextEditingControllerHookState createState() =>
      _SimpleTextEditingControllerHookState();
}

class _SimpleTextEditingControllerHookState
    extends
        HookState<
          SimpleCalculatorTextEditingController,
          _SimpleCalculatorEditingControllerHook
        > {
  late final SimpleCalculatorTextEditingController _controller;

  @override
  void initHook() {
    super.initHook();
    _controller = SimpleCalculatorTextEditingController(
      initialValue: hook.initialValue,
    );
  }

  @override
  SimpleCalculatorTextEditingController build(BuildContext context) =>
      _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
