import 'package:flutter_test/flutter_test.dart';
import 'package:workspace/main.dart';

void main() {
  Future<void> press(WidgetTester tester, String input) async {
    await tester.tap(find.text(input).last);
  }

  testWidgets('evaluates with operator precedence and shows accumulator', (
    tester,
  ) async {
    await tester.pumpWidget(const CalculatorApp());

    for (final input in ['2', '+', '3', '*', '4', '=']) {
      await press(tester, input);
    }
    await tester.pump();

    expect(find.text('2+3*4 = 14'), findsOneWidget);
  });

  testWidgets('clear resets the expression and result display', (tester) async {
    await tester.pumpWidget(const CalculatorApp());

    for (final input in ['9', '*', '9', '=']) {
      await press(tester, input);
    }
    await press(tester, 'C');
    await tester.pump();

    expect(find.text('0'), findsNWidgets(2));
  });

  testWidgets('division by zero reports an error without crashing', (
    tester,
  ) async {
    await tester.pumpWidget(const CalculatorApp());

    for (final input in ['8', '/', '0', '=']) {
      await press(tester, input);
    }
    await tester.pump();

    expect(find.text('Unable to calculate this expression'), findsOneWidget);
  });
}
