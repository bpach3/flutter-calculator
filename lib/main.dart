import 'package:expressions/expressions.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 55, 135, 23),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  static const _operators = {'+', '-', '*', '/'};
  String _expression = '';
  String _display = '0';
  String? _error;
  bool _justEvaluated = false;

  void _press(String value) {
    setState(() {
      if (value == 'C') {
        _clear();
        return;
      }
      if (value == '=') {
        _evaluate();
        return;
      }

      if (_justEvaluated && !_operators.contains(value)) {
        _expression = '';
      }
      _justEvaluated = false;
      _error = null;

      if (_operators.contains(value)) {
        if (_expression.isEmpty) {
          if (value != '-') return;
        } else if (_operators.contains(_expression[_expression.length - 1])) {
          _expression = _expression.substring(0, _expression.length - 1);
        }
      }

      _expression += value;
      _display = _expression;
    });
  }

  void _clear() {
    _expression = '';
    _display = '0';
    _error = null;
    _justEvaluated = false;
  }

  void _evaluate() {
    if (_expression.isEmpty) return;
    try {
      final parsed = Expression.parse(_expression);
      final result = const ExpressionEvaluator().eval(parsed, {});
      if (result is! num || !result.isFinite) {
        throw const FormatException('The result is not a finite number.');
      }
      final formatted = _formatResult(result);
      _display = '$_expression = $formatted';
      _expression = formatted;
      _justEvaluated = true;
      _error = null;
    } catch (_) {
      _error = 'Unable to calculate this expression';
      _display = _expression;
    }
  }

  String _formatResult(num result) {
    if (result is int || result == result.roundToDouble()) {
      return result.toInt().toString();
    }
    return result.toString();
  }

  Color _buttonColor(String label, ColorScheme colors) {
    if (label == '=') return colors.primary;
    if (label == 'C') return colors.errorContainer;
    if (_operators.contains(label)) return colors.secondaryContainer;
    return colors.surfaceContainerHighest;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              child: Column(
                children: [
                  Text(
                    'GitHub Copilot\'s Calculator',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: colors.primary,
                        ),
                  ),
                  const SizedBox(height: 22),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: colors.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          reverse: true,
                          child: Text(
                            _display,
                            maxLines: 1,
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: colors.onPrimaryContainer,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 28,
                    child: _error == null
                        ? null
                        : Text(
                            _error!,
                            style: TextStyle(color: colors.error),
                          ),
                  ),
                  const SizedBox(height: 8),
                  GridView.count(
                    crossAxisCount: 4,
                    shrinkWrap: true,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.45,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      for (final label in [
                        '7', '8', '9', '/',
                        '4', '5', '6', '*',
                        '1', '2', '3', '-',
                        'C', '0', '=', '+',
                      ])
                        _CalculatorButton(
                          label: label,
                          backgroundColor: _buttonColor(label, colors),
                          foregroundColor: label == '='
                              ? colors.onPrimary
                              : label == 'C'
                                  ? colors.onErrorContainer
                                  : colors.onSurface,
                          onPressed: () => _press(label),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CalculatorButton extends StatelessWidget {
  const _CalculatorButton({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onPressed,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
      ),
      child: Text(label),
    );
  }
}
