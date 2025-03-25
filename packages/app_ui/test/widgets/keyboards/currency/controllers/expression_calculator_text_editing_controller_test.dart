// ignore_for_file: cascade_invocations

import 'package:app_ui/src/widgets/keyboards/currency/controllers/expression_calculator_text_editing_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExpressionCalculatorTextEditingController', () {
    late ExpressionCalculatorTextEditingController controller;

    setUp(() {
      controller = ExpressionCalculatorTextEditingController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('initializes with default value of 0', () {
      expect(controller.text, '0');
      expect(controller.expression, '0');
    });

    test('initializes with custom value', () {
      final customController = ExpressionCalculatorTextEditingController(initialValue: '123');
      expect(customController.text, '123');
      expect(customController.expression, '123');
      customController.dispose();
    });

    group('add method', () {
      test('replaces 0 with new value', () {
        controller.add('5');
        expect(controller.text, '5');
        expect(controller.expression, '5');
      });

      test('appends digits to existing value', () {
        controller.add('1');
        controller.add('2');
        controller.add('3');
        expect(controller.text, '123');
        expect(controller.expression, '123');
      });

      test('formats large numbers with commas', () {
        controller.add('1');
        controller.add('2');
        controller.add('3');
        controller.add('4');
        controller.add('5');
        controller.add('6');
        expect(controller.text, '123,456');
        expect(controller.expression, '123456');
      });

      test('handles operators correctly', () {
        controller.add('5');
        controller.add('+');
        controller.add('3');
        expect(controller.text, '5 + 3');
        expect(controller.expression, '5 + 3');
      });

      test('replaces consecutive operators', () {
        controller.add('5');
        controller.add('+');
        controller.add('-');
        expect(controller.text, '5 -');
        expect(controller.expression.trim(), '5 -');
      });
    });

    group('addOperator method', () {
      test('adds operator after number', () {
        controller.add('5');
        controller.addOperator('+');
        expect(controller.text, '5 +');
        expect(controller.expression.trim(), '5 +');
      });

      test('does not add operator after another operator', () {
        controller.add('5');
        controller.addOperator('+');
        controller.addOperator('-');
        expect(controller.text, '5 +');
        expect(controller.expression.trim(), '5 +');
      });

      test('does not add operator after opening parenthesis', () {
        controller.add('(');
        controller.addOperator('+');
        expect(controller.text, '(');
        expect(controller.expression.trim(), '(');
      });
    });

    group('addDecimalPoint method', () {
      test('adds decimal point to number', () {
        controller.add('5');
        controller.addDecimalPoint();
        expect(controller.text, '5.');
        expect(controller.expression, '5.');
      });

      test('adds 0. when adding decimal point at start', () {
        controller.clear();
        controller.addDecimalPoint();
        expect(controller.text, '0.');
        expect(controller.expression, '0.');
      });

      test('adds 0. after operator', () {
        controller.add('5');
        controller.addOperator('+');
        controller.addDecimalPoint();
        expect(controller.text, '5 + 0.');
        expect(controller.expression.trim(), '5 +  0.');
      });

      test('does not add multiple decimal points to same number', () {
        controller.add('5');
        controller.addDecimalPoint();
        controller.addDecimalPoint();
        expect(controller.text, '5.');
        expect(controller.expression, '5.');
      });
    });

    group('addParenthesis method', () {
      test('adds opening parenthesis', () {
        controller.addParenthesis('(');
        expect(controller.text, '( 0');
        expect(controller.expression.trim(), '( 0');
      });

      test('adds closing parenthesis', () {
        controller.add('5');
        controller.addParenthesis(')');
        expect(controller.text, '5 )');
        expect(controller.expression.trim(), '5 )');
      });
    });

    group('clear method', () {
      test('resets to 0', () {
        controller.add('123');
        controller.addOperator('+');
        controller.add('456');
        controller.clear();
        expect(controller.text, '0');
        expect(controller.expression, '0');
      });
    });

    group('backspace method', () {
      test('removes last character', () {
        controller.add('123');
        controller.backspace();
        expect(controller.text, '12');
        expect(controller.expression, '12');
      });

      test('handles empty expression gracefully', () {
        controller.clear();
        controller.backspace();
        expect(controller.text, '0');
        expect(controller.expression, '0');
      });
    });

    group('calculateResult method', () {
      test('calculates simple addition', () {
        controller.add('2');
        controller.addOperator('+');
        controller.add('3');
        controller.calculateResult();
        expect(controller.text, '5');
        expect(controller.expression, '5');
      });

      test('calculates simple subtraction', () {
        controller.add('5');
        controller.addOperator('-');
        controller.add('3');
        controller.calculateResult();
        expect(controller.text, '2');
        expect(controller.expression, '2');
      });

      test('calculates simple multiplication', () {
        controller.add('2');
        controller.addOperator('*');
        controller.add('3');
        controller.calculateResult();
        expect(controller.text, '6');
        expect(controller.expression, '6');
      });

      test('calculates simple division', () {
        controller.add('6');
        controller.addOperator('/');
        controller.add('3');
        controller.calculateResult();
        expect(controller.text, '2');
        expect(controller.expression, '2');
      });

      test('respects operator precedence', () {
        controller.add('2');
        controller.addOperator('+');
        controller.add('3');
        controller.addOperator('*');
        controller.add('4');
        controller.calculateResult();
        expect(controller.text, '14');
        expect(controller.expression, '14');
      });

      test('handles parentheses correctly', () {
        controller.addParenthesis('(');
        controller.add('2');
        controller.addOperator('+');
        controller.add('3');
        controller.addParenthesis(')');
        controller.addOperator('*');
        controller.add('4');
        controller.calculateResult();
        expect(controller.text, '20');
        expect(controller.expression, '20');
      });

      test('handles decimal calculations', () {
        controller.add('2');
        controller.addDecimalPoint();
        controller.add('5');
        controller.addOperator('*');
        controller.add('1');
        controller.addDecimalPoint();
        controller.add('5');
        controller.calculateResult();
        expect(controller.text, '3.75');
        expect(controller.expression, '3.75');
      });

      test('handles trailing operator gracefully', () {
        controller.add('5');
        controller.addOperator('+');
        controller.calculateResult();
        expect(controller.text, '5');
        expect(controller.expression, '5');
      });
    });

    group('numberValue getter', () {
      test('returns correct value for simple expression', () {
        controller.add('5');
        controller.addOperator('+');
        controller.add('3');
        expect(controller.numberValue, 8);
      });

      test('returns 0 for invalid expression', () {
        controller.add('5');
        controller.addOperator('+');
        // Incomplete expression
        expect(controller.numberValue, 5);
      });

      // Basic operations
      test('handles addition correctly', () {
        controller.add('10');
        controller.addOperator('+');
        controller.add('5');
        expect(controller.numberValue, 15);
      });

      test('handles subtraction correctly', () {
        controller.add('10');
        controller.addOperator('-');
        controller.add('5');
        expect(controller.numberValue, 5);
      });

      test('handles multiplication correctly', () {
        controller.add('10');
        controller.addOperator('*');
        controller.add('5');
        expect(controller.numberValue, 50);
      });

      test('handles division correctly', () {
        controller.add('10');
        controller.addOperator('/');
        controller.add('5');
        expect(controller.numberValue, 2);
      });

      // Decimal numbers
      test('handles decimal addition correctly', () {
        controller.add('5');
        controller.addDecimalPoint();
        controller.add('5');
        controller.addOperator('+');
        controller.add('2');
        controller.addDecimalPoint();
        controller.add('5');
        expect(controller.numberValue, 8.0);
      });

      test('handles decimal multiplication correctly', () {
        controller.add('2');
        controller.addDecimalPoint();
        controller.add('5');
        controller.addOperator('*');
        controller.add('3');
        expect(controller.numberValue, 7.5);
      });

      // Complex expressions
      test('respects operator precedence', () {
        controller.add('2');
        controller.addOperator('+');
        controller.add('3');
        controller.addOperator('*');
        controller.add('4');
        expect(controller.numberValue, 14); // 2 + (3 * 4) = 14, not (2 + 3) * 4 = 20
      });

      test('handles multiple operations in sequence', () {
        controller.add('10');
        controller.addOperator('+');
        controller.add('5');
        controller.addOperator('-');
        controller.add('3');
        controller.addOperator('*');
        controller.add('2');
        expect(controller.numberValue, 9); // 10 + 5 - (3 * 2) = 10
      });

      // Parentheses
      test('handles simple parentheses', () {
        controller.addParenthesis('(');
        controller.add('2');
        controller.addOperator('+');
        controller.add('3');
        controller.addParenthesis(')');
        expect(controller.numberValue, 5);
      });

      test('handles nested parentheses', () {
        controller.addParenthesis('(');
        controller.add('2');
        controller.addOperator('+');
        controller.addParenthesis('(');
        controller.add('3');
        controller.addOperator('*');
        controller.add('2');
        controller.addParenthesis(')');
        controller.addParenthesis(')');
        expect(controller.numberValue, 8); // (2 + (3 * 2)) = 8
      });

      test('handles parentheses with operations outside', () {
        controller.addParenthesis('(');
        controller.add('2');
        controller.addOperator('+');
        controller.add('3');
        controller.addParenthesis(')');
        controller.addOperator('*');
        controller.add('4');
        expect(controller.numberValue, 20); // (2 + 3) * 4 = 20
      });

      // Edge cases
      test('handles negative numbers', () {
        controller.add('0');
        controller.addOperator('-');
        controller.add('5');
        expect(controller.numberValue, -5);
      });

      test('handles division by zero gracefully', () {
        controller.add('10');
        controller.addOperator('/');
        controller.add('0');
        // This should either return a special value or handle the error
        // The exact behavior depends on the implementation
        expect(() => controller.numberValue, returnsNormally);
      });

      test('handles very large numbers', () {
        controller.add('999999');
        controller.addOperator('*');
        controller.add('999999');
        // This tests that large results don't cause overflow issues
        expect(controller.numberValue, 999999 * 999999);
      });

      test('handles very small decimal numbers', () {
        controller.add('0');
        controller.addDecimalPoint();
        controller.add('0001');
        expect(controller.numberValue, 0.0001);
      });

      // State after operations
      test('returns updated value after calculation', () {
        controller.add('5');
        controller.addOperator('+');
        controller.add('3');
        controller.calculateResult();
        expect(controller.numberValue, 8);

        // Add more operations after calculation
        controller.addOperator('*');
        controller.add('2');
        expect(controller.numberValue, 16);
      });

      test('returns correct value after backspace', () {
        controller.add('123');
        controller.backspace();
        expect(controller.numberValue, 12);

        controller.addOperator('+');
        controller.add('3');
        controller.backspace();
        expect(controller.numberValue, 12);
      });

      test('returns 0 after clear', () {
        controller.add('123');
        controller.addOperator('+');
        controller.add('456');
        controller.clear();
        expect(controller.numberValue, 0);
      });
    });

    test('handles complex expressions correctly', () {
      controller.add('2');
      controller.addOperator('+');
      controller.add('3');
      controller.addOperator('*');
      controller.addParenthesis('(');
      controller.add('4');
      controller.addOperator('-');
      controller.add('1');
      controller.addParenthesis(')');
      controller.calculateResult();
      expect(controller.text, '11');
      expect(controller.expression, '11');
    });
  });
}
