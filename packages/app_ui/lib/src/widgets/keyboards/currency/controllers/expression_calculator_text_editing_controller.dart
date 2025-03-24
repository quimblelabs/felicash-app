import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A custom text editing controller for currency calculations
///
/// This controller extends the [TextEditingController] class and provides
/// methods for performing currency calculations.
///
class ExpressionCalculatorTextEditingController extends TextEditingController {
  /// Creates a currency text editing controller
  ///
  /// The [initialValue] parameter is the initial value of the text field.
  /// The default value is 0.
  ExpressionCalculatorTextEditingController({
    String initialValue = '0',
  }) {
    _expression = initialValue;
    _updateText();
  }

  final NumberFormat _formatter = NumberFormat('#,###.#####');

  String _expression = '';

  int _maxDecimalPlaces = 0;

  /// Adds a numeric string or decimal point directly to the current expression.
  ///
  /// Example:
  /// ```dart
  /// controller.add("123000");
  /// controller.add(".");
  /// controller.add("5");
  /// ```
  void add(String value) {
    if (double.tryParse(_expression) == 0) {
      if (_isOperator(value)) return;
      _expression = value;
    } else {
      if (_isOperator(value) || value == '(' || value == ')') {
        final lastChar = _expression[_expression.length - 2];
        if (_isOperator(lastChar) || lastChar == '(' || lastChar == ')') {
          _expression = _expression.substring(0, _expression.length - 3);
        }
        _expression += ' $value ';
      } else {
        _expression += value;
      }
    }
    if (_expression.contains('.')) {
      final decimalSeparatorIndex = <int>[];
      final endNumberHasDecimalSeparator = <int>[];
      for (var i = 0; i < _expression.length; i++) {
        if (_expression[i] == '.') {
          decimalSeparatorIndex.add(i);
          for (var j = i + 1; j < _expression.length; j++) {
            if (_expression[j] == ' ' || j == _expression.length - 1) {
              endNumberHasDecimalSeparator.add(j - 1);
              break;
            }
          }
        }
      }
      for (var i = 0; i < decimalSeparatorIndex.length; i++) {
        final length = endNumberHasDecimalSeparator[i] - decimalSeparatorIndex[i];
        if (length > _maxDecimalPlaces) {
          _maxDecimalPlaces = length;
        }
      }
    }
    _updateText();
  }

  /// Adds an operator (`+`, `-`, `*`, `/`) to the expression.
  ///
  /// Ensures the operator is placed only after a valid number or closing parenthesis.
  ///
  /// Example:
  /// ```dart
  /// controller.addOperator("+");
  /// controller.addOperator("-");
  /// ```
  void addOperator(String operator) {
    if (_expression.isNotEmpty &&
        !_isOperator(_expression.trim().characters.last) //
        &&
        !_expression.trim().endsWith('(')) {
      _expression += ' $operator ';
    }
    _updateText();
  }

  /// Adds a decimal point `.` to the current number.
  ///
  /// Automatically prepends `0.` if inserted at a valid position (like after an operator).
  ///
  /// Example:
  /// ```dart
  /// controller.addDecimalPoint();
  /// ```
  void addDecimalPoint() {
    final trimmed = _expression.trim();
    final lastChar = trimmed.isNotEmpty ? trimmed[trimmed.length - 1] : '';

    if (_expression.isEmpty || RegExp(r'[+\-*/(]').hasMatch(lastChar)) {
      _expression += '0.';
    } else if (!lastChar.contains('.')) {
      _expression += '.';
    }

    _updateText();
  }

  /// Adds a parenthesis to the current expression: `(` or `)`.
  ///
  /// Example:
  /// ```dart
  /// controller.addParenthesis("(");
  /// controller.addParenthesis(")");
  /// ```
  void addParenthesis(String parenthesis) {
    _expression += ' $parenthesis ';
    _updateText();
  }

  /// Clears the current expression and resets the text to empty.
  ///
  /// Example:
  /// ```dart
  /// controller.clear();
  /// ```
  @override
  void clear() {
    _expression = '0';
    _maxDecimalPlaces = 0;
    _updateText();
  }

  /// Removes the last character from the current expression.
  ///
  /// Acts like a backspace key.
  ///
  /// Example:
  /// ```dart
  /// controller.backspace();
  /// ```
  void backspace() {
    if (_expression.isNotEmpty) {
      _expression = _expression.trimRight();
      _expression = _expression.substring(0, _expression.length - 1);
    }
    _updateText();
  }

  /// Parses and evaluates the current mathematical expression string.
  ///
  /// Supports numbers, decimals, operators (`+`, `-`, `*`, `/`) and parentheses.
  ///
  /// Result is shown with 3 decimal digits (e.g. `123.456`).
  ///
  /// Example:
  /// ```dart
  /// controller.add("123");
  /// controller.addOperator("+");
  /// controller.add("456");
  /// controller.calculateResult(); // → 579.000
  /// ```
  void calculateResult() {
    try {
      String cleanExpr = _expression.trim();

      if (cleanExpr.isNotEmpty && RegExp(r'[+\-*/]').hasMatch(cleanExpr[cleanExpr.length - 1])) {
        final parts = cleanExpr.split(RegExp(r'\s+'))..removeLast();
        cleanExpr = parts.join(' ');
      }

      final postfix = _toPostfix(cleanExpr);
      final result = _evaluatePostfix(postfix);

      _expression = result.toStringAsFixed(_maxDecimalPlaces);
      _updateText();
    } catch (e, stackTrace) {
      log('Error evaluating expression: $e', stackTrace: stackTrace);
    }
  }

  void _updateText() {
    final pattern = RegExp(r'(\d+(\.\d+)?|[()+\-*/])');
    final matches = pattern.allMatches(_expression);

    final formatted = matches.map((match) {
      final token = match.group(0)!;
      final number = double.tryParse(token);
      if (number != null) {
        return _formatter.format(number);
      }
      return token;
    }).join(' ');

    text = formatted.replaceAll(RegExp(r'\s+'), ' ').trim();
    selection = TextSelection.collapsed(offset: text.length);
    notifyListeners();
    log('Expression: $_expression');
  }

  bool _isOperator(String ch) => ['+', '-', '*', '/'].contains(ch);

  int _precedence(String op) {
    if (op == '+' || op == '-') return 1;
    if (op == '*' || op == '/') return 2;
    return 0;
  }

  List<String> _toPostfix(String infix) {
    final output = <String>[];
    final stack = <String>[];
    final tokens = infix.split(RegExp(r'\s+')).where((t) => t.isNotEmpty).toList();

    for (final token in tokens) {
      if (_isNumber(token)) {
        output.add(token);
      } else if (_isOperator(token)) {
        while (stack.isNotEmpty &&
            _isOperator(stack.last) //
            &&
            _precedence(token) <= _precedence(stack.last)) {
          output.add(stack.removeLast());
        }
        stack.add(token);
      } else if (token == '(') {
        stack.add(token);
      } else if (token == ')') {
        while (stack.isNotEmpty && stack.last != '(') {
          output.add(stack.removeLast());
        }
        if (stack.isNotEmpty && stack.last == '(') {
          stack.removeLast();
        }
      }
    }

    while (stack.isNotEmpty) {
      output.add(stack.removeLast());
    }

    return output;
  }

  double _evaluatePostfix(List<String> postfix) {
    final stack = <double>[];

    for (final token in postfix) {
      if (_isNumber(token)) {
        stack.add(double.parse(token));
      } else if (_isOperator(token)) {
        final b = stack.removeLast();
        final a = stack.removeLast();
        switch (token) {
          case '+':
            stack.add(a + b);
          case '-':
            stack.add(a - b);
          case '*':
            stack.add(a * b);
          case '/':
            stack.add(a / b);
        }
      }
    }

    return stack.single;
  }

  bool _isNumber(String str) {
    return double.tryParse(str) != null;
  }

  /// Returns the current expression as a string.
  String get expression => _expression;

  /// Returns the current value of the expression as a double.
  ///
  double get numberValue {
    try {
      var cleanExpr = _expression.trim();

      if (cleanExpr.isNotEmpty && RegExp(r'[+\-*/]').hasMatch(cleanExpr[cleanExpr.length - 1])) {
        final parts = cleanExpr.split(RegExp(r'\s+'))..removeLast();
        cleanExpr = parts.join(' ');
      }

      final postfix = _toPostfix(cleanExpr);
      return _evaluatePostfix(postfix);
    } catch (_) {
      return 0;
    }
  }
}
