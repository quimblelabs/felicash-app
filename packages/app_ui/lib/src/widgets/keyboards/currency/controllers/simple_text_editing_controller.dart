import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A custom text editing controller for currency calculations
///
/// This controller extends the [TextEditingController] class and provides
/// methods for performing currency calculations.
///
/// The [SimpleTextEditingController] class is used to handle currency calculations
/// in a text field. It extends the [TextEditingController] class and provides methods
/// for performing addition, subtraction, multiplication, and division operations.
///
/// The following example demonstrates how to use the [SimpleTextEditingController]
/// class to create a text field that handles currency calculations:
///
///  The [SimpleTextEditingController] class provides the following methods for
///  performing currency calculations:
///  - [plus]: Performs addition operation
///  - [minus]: Performs subtraction operation
///  - [multiply]: Performs multiplication operation
///  - [divide]: Performs division operation
///  - [addDigit]: Adds a digit to the current number
///  - [addDecimalPoint]: Adds a decimal point to the current number
///  - [backspace]: Removes the last digit from the current number
///  - [clear]: Clears the current number and operation
///  - [calculateResult]: Calculates the result of the current operation
///
class SimpleTextEditingController extends TextEditingController {
  /// Creates a currency text editing controller
  ///
  /// The [initialValue] parameter is the initial value of the text field.
  /// The default value is 0.
  ///
  SimpleTextEditingController({
    double initialValue = 0,
  }) : _formatter = NumberFormat('#,###.##') {
    _currentValue = initialValue;
    text = _formattedText;
  }

  double _currentValue = 0;
  double _storedValue = 0;
  String _currentOperation = '';
  bool _isNewNumber = true;
  int _decimalPlaces = 0;
  bool _isDecimalPointMode = false;
  final NumberFormat _formatter;

  /// Performs addition operation
  ///
  /// This method:
  /// 1. Executes the pending operation if any exists
  /// 2. Sets the current operation to addition ('+')
  /// 3. Marks that the next input will be a new number
  void plus() {
    _performOperation();
    _currentOperation = '+';
    _isNewNumber = true;
  }

  /// Performs subtraction operation
  ///
  /// This method:
  /// 1. Executes the pending operation if any exists
  /// 2. Sets the current operation to subtraction ('-')
  /// 3. Marks that the next input will be a new number
  void minus() {
    _performOperation();
    _currentOperation = '-';
    _isNewNumber = true;
  }

  /// Performs multiplication operation
  ///
  /// This method:
  /// 1. Executes the pending operation if any exists
  /// 2. Sets the current operation to multiplication ('*')
  /// 3. Marks that the next input will be a new number
  void multiply() {
    _performOperation();
    _currentOperation = '*';
    _isNewNumber = true;
  }

  /// Performs division operation
  ///
  /// This method:
  /// 1. Executes the pending operation if any exists
  /// 2. Sets the current operation to division ('/')
  /// 3. Marks that the next input will be a new number
  void divide() {
    _performOperation();
    _currentOperation = '/';
    _isNewNumber = true;
  }

  /// Adds a digit to the current number
  ///
  /// This method:
  /// 1. If the current number is a new number, it sets the current value to the digit
  /// 2. If the current number is not a new number, it appends the digit to the current value
  /// 3. Updates the text field with the current value
  /// 4. Marks that the current number is not a new number
  void addDigit(String digit) {
    if (_isNewNumber) {
      _storedValue = _currentValue;
      _currentValue = 0;
      _decimalPlaces = 0;
      _isDecimalPointMode = false;
      _isNewNumber = false;
    }

    if (_isDecimalPointMode) {
      _decimalPlaces++;
      _currentValue += int.parse(digit) / (_pow10(_decimalPlaces));
    } else {
      _currentValue = _currentValue * 10 + int.parse(digit);
    }

    _updateText();
  }

  /// Adds a decimal point to the current number
  ///
  /// This method:
  /// 1. If the current number already contains a decimal point, it does nothing
  /// 2. Otherwise, it appends a decimal point to the current value
  void addDecimalPoint() {
    if (!_isDecimalPointMode) {
      _isDecimalPointMode = true;
    }
    _updateText();
  }

  /// Adds a decimal point to the current number
  ///
  /// This method:
  /// 1. If the current number is a new number, it sets the current value to 0.0
  /// 2. If the current number already contains a decimal point, it does nothing
  /// 3. Otherwise, it appends a decimal point to the current value
  /// 4. Updates the text field with the current value
  /// 5. Marks that the current number is not a new number
  void backspace() {
    if (_isNewNumber) {
      _currentValue = 0;
      _decimalPlaces = 0;
      _isDecimalPointMode = false;
    } else {
      if (_isDecimalPointMode) {
        if (_decimalPlaces > 0) {
          _currentValue = (_currentValue * _pow10(_decimalPlaces)).floorToDouble();
          _decimalPlaces--;
          _currentValue = _currentValue / _pow10(_decimalPlaces);
        } else {
          _isDecimalPointMode = false;
        }
      } else {
        _currentValue = (_currentValue ~/ 10).toDouble();
      }
    }
    _updateText();
  }

  /// Clears the current number and operation
  ///
  /// This method:
  /// 1. Sets the current value to 0
  /// 2. Sets the stored value to 0
  /// 3. Clears the current operation
  /// 4. Marks that the next input will be a new number
  /// 5. Updates the text field with the current value
  @override
  void clear() {
    _currentValue = 0;
    _storedValue = 0;
    _currentOperation = '';
    _decimalPlaces = 0;
    _isDecimalPointMode = false;
    _isNewNumber = true;
    _updateText();
  }

  /// Calculates the result of the current operation
  ///
  /// This method:
  /// 1. Executes the pending operation if any exists
  /// 2. Clears the current operation
  /// 3. Marks that the next input will be a new number
  /// 4. Updates the text field with the current value
  void calculateResult() {
    _performOperation();
    _currentOperation = '';
    _isNewNumber = true;
    _updateText();
  }

  /// Executes the pending operation
  ///
  /// This method:
  /// 1. If the current operation is empty, it sets the stored value to the current value
  /// 2. Otherwise, it performs the corresponding operation based on the current operation
  /// 3. Updates the text field with the current value
  /// 4. Sets the stored value to the current value
  /// 5. Marks that the next input will be a new number
  /// 6. Updates the text field with the current value
  void _performOperation() {
    switch (_currentOperation) {
      case '+':
        _currentValue = _storedValue + _currentValue;
      case '-':
        _currentValue = _storedValue - _currentValue;
      case '*':
        _currentValue = _storedValue * _currentValue;
      case '/':
        if (_currentValue != 0) {
          _currentValue = _storedValue / _currentValue;
        }
    }
    _storedValue = _currentValue;
  }

  /// Updates the text field with the current value
  ///
  /// This method:
  /// 1. Sets the text field's text to the current value as a string with two decimal places
  /// 2. Notifies the listeners that the text has changed
  /// 3. Sets the selection to the end of the text field
  ///
  /// The [notifyListeners] method is called to notify the listeners that the text has changed.
  /// The [selection] property is set to a new [TextSelection] object with the base and extent
  /// set to the end of the text field.
  void _updateText() {
    text = _formattedText;
    notifyListeners();
    _log();
  }

  String get _formattedText {
    if (_isDecimalPointMode && _decimalPlaces == 0) {
      final number = double.parse(_currentValue.toStringAsFixed(_decimalPlaces));
      return '${_formatter.format(number)}.';
    } else if (_decimalPlaces > 0) {
      final number = double.parse(_currentValue.toStringAsFixed(_decimalPlaces));
      return _formatter.format(number);
    } else {
      final number = _currentValue;
      return _formatter.format(number);
    }
  }

  int _pow10(int exp) => List.filled(exp, 10).fold(1, (a, b) => a * b);

  void _log() {
    log(
      'text: $text, currentValue: $_currentValue, storedValue: $_storedValue, '
      'currentOperation: $_currentOperation, isNewNumber: $_isNewNumber, '
      'isDecimalPointMode: $_isDecimalPointMode, decimalPlaces: $_decimalPlaces',
    );
  }

  /// Builds a `TextSpan` with the current text and style.
  ///
  /// This method is used to display the text in the text field.
  ///
  /// The [context] parameter is the build context.
  /// The [style] parameter is the text style.
  /// The [withComposing] parameter indicates whether to include the composing text.
  ///
  /// Returns a `TextSpan` with the current text and style.
  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    required bool withComposing,
    TextStyle? style,
  }) {
    return TextSpan(text: text, style: style);
  }
}
