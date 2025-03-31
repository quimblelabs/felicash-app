import 'package:app_ui/src/widgets/keyboards/currency/controllers/expression_calculator_text_editing_controller.dart';
import 'package:flutter/material.dart';

/// A custom keyboard widget for currency calculations
class CurrencyKeyboard extends StatelessWidget {
  /// Creates a currency keyboard
  const CurrencyKeyboard({
    required this.controller,
    super.key,
    this.operatorButtonBackgroundColor,
    this.operatorButtonTextColor,
    this.numberButtonBackgroundColor,
    this.numberButtonTextColor,
    this.backspaceButtonBackgroundColor,
    this.backspaceButtonTextColor,
  });

  /// The controller that handles currency calculations
  final ExpressionCalculatorTextEditingController controller;

  /// The background color of operator buttons
  final Color? operatorButtonBackgroundColor;

  /// The text color of operator buttons
  final Color? operatorButtonTextColor;

  /// The background color of number buttons
  final Color? numberButtonBackgroundColor;

  /// The text color of number buttons
  final Color? numberButtonTextColor;

  /// The background color of the backspace button
  final Color? backspaceButtonBackgroundColor;

  ///  The text color of the backspace button
  final Color? backspaceButtonTextColor;

  @override
  Widget build(BuildContext context) {
    final operatorButtonBackgroundColor = this.operatorButtonBackgroundColor ?? Colors.white;
    final operatorButtonTextColor = this.operatorButtonTextColor ?? Colors.black;
    final numberButtonBackgroundColor = this.numberButtonBackgroundColor ?? Colors.grey.shade100;
    final numberButtonTextColor = this.numberButtonTextColor ?? Colors.black;
    final backspaceButtonBackgroundColor = this.backspaceButtonBackgroundColor ?? Colors.white;
    final backspaceButtonTextColor = this.backspaceButtonTextColor ?? Colors.black;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          _ButtonRow(buttons: [
            _OperatorButton(
              text: 'C',
              onPressed: controller.clear,
              backgroundColor: operatorButtonBackgroundColor,
              textColor: operatorButtonTextColor,
            ),
            _OperatorButton(
              text: '/',
              onPressed: () => controller.add('/'),
              backgroundColor: operatorButtonBackgroundColor,
              textColor: operatorButtonTextColor,
            ),
            _OperatorButton(
              text: '*',
              onPressed: () => controller.add('*'),
              backgroundColor: operatorButtonBackgroundColor,
              textColor: operatorButtonTextColor,
            ),
            _BackSpaceButton(
              onPressed: controller.backspace,
              backgroundColor: backspaceButtonBackgroundColor,
              textColor: backspaceButtonTextColor,
            ),
          ]),
          const SizedBox(height: 12),
          _ButtonRow(
            buttons: [
              _NumberButton(
                text: '1',
                onPressed: () => controller.add('1'),
                backgroundColor: numberButtonBackgroundColor,
                textColor: numberButtonTextColor,
              ),
              _NumberButton(
                text: '2',
                onPressed: () => controller.add('2'),
                backgroundColor: numberButtonBackgroundColor,
                textColor: numberButtonTextColor,
              ),
              _NumberButton(
                text: '3',
                onPressed: () => controller.add('3'),
                backgroundColor: numberButtonBackgroundColor,
                textColor: numberButtonTextColor,
              ),
              _OperatorButton(
                text: '+',
                onPressed: () => controller.add('+'),
                backgroundColor: operatorButtonBackgroundColor,
                textColor: operatorButtonTextColor,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _ButtonRow(
            buttons: [
              _NumberButton(
                text: '4',
                onPressed: () => controller.add('4'),
                backgroundColor: numberButtonBackgroundColor,
                textColor: numberButtonTextColor,
              ),
              _NumberButton(
                text: '5',
                onPressed: () => controller.add('5'),
                backgroundColor: numberButtonBackgroundColor,
                textColor: numberButtonTextColor,
              ),
              _NumberButton(
                text: '6',
                onPressed: () => controller.add('6'),
                backgroundColor: numberButtonBackgroundColor,
                textColor: numberButtonTextColor,
              ),
              _OperatorButton(
                text: '-',
                onPressed: () => controller.add('-'),
                backgroundColor: operatorButtonBackgroundColor,
                textColor: operatorButtonTextColor,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _ButtonRow(
            buttons: [
              _NumberButton(
                text: '7',
                onPressed: () => controller.add('7'),
                backgroundColor: numberButtonBackgroundColor,
                textColor: numberButtonTextColor,
              ),
              _NumberButton(
                text: '8',
                onPressed: () => controller.add('8'),
                backgroundColor: numberButtonBackgroundColor,
                textColor: numberButtonTextColor,
              ),
              _NumberButton(
                text: '9',
                onPressed: () => controller.add('9'),
                backgroundColor: numberButtonBackgroundColor,
                textColor: numberButtonTextColor,
              ),
              _OperatorButton(
                text: '=',
                onPressed: controller.calculateResult,
                backgroundColor: operatorButtonBackgroundColor,
                textColor: operatorButtonTextColor,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _ButtonRow(
            buttons: [
              _NumberButton(text: '.', onPressed: controller.addDecimalPoint),
              _NumberButton(text: '0', onPressed: () => controller.add('0')),
              _NumberButton(
                text: '000',
                onPressed: () {
                  controller
                    ..add('0')
                    ..add('0')
                    ..add('0');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ButtonRow extends StatelessWidget {
  const _ButtonRow({
    required this.buttons,
  });

  final List<Widget> buttons;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final button in buttons) ...[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: button,
              ),
            ),
            if (button != buttons.last) const SizedBox(width: 12),
          ],
        ],
      ),
    );
  }
}

class _OperatorButton extends StatelessWidget {
  const _OperatorButton({
    required this.text,
    required this.onPressed,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
  });

  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(fontSize: 14, color: textColor),
        ),
      ),
    );
  }
}

class _NumberButton extends StatelessWidget {
  const _NumberButton({
    required this.text,
    required this.onPressed,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
  });

  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(fontSize: 14, color: textColor),
        ),
      ),
    );
  }
}

class _BackSpaceButton extends StatelessWidget {
  const _BackSpaceButton({
    required this.onPressed,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
  });

  final VoidCallback onPressed;

  final Color backgroundColor;

  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor,
        ),
        onPressed: onPressed,
        child: Icon(
          Icons.backspace_outlined,
          color: textColor,
          size: 20,
        ),
      ),
    );
  }
}
