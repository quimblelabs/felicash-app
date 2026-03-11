import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// A hook that provides a calculator text editing controller
///
/// This hook creates and manages a [TextEditingController] with
/// expression calculation capabilities.
ExpressionCalculatorTextEditingController useExpressionCalculatorController([
  String initialValue = '0',
]) {
  return use(_ExpressionCalculatorHook(initialValue: initialValue));
}

class _ExpressionCalculatorHook
    extends Hook<ExpressionCalculatorTextEditingController> {
  const _ExpressionCalculatorHook({required this.initialValue});

  final String initialValue;

  @override
  _ExpressionCalculatorHookState createState() =>
      _ExpressionCalculatorHookState();
}

class _ExpressionCalculatorHookState
    extends
        HookState<
          ExpressionCalculatorTextEditingController,
          _ExpressionCalculatorHook
        > {
  late final ExpressionCalculatorTextEditingController _controller;

  @override
  void initHook() {
    super.initHook();
    _controller = ExpressionCalculatorTextEditingController(
      initialValue: hook.initialValue,
    );
  }

  @override
  ExpressionCalculatorTextEditingController build(BuildContext context) =>
      _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
