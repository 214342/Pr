import 'dart:math';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Калькулятор',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _output = "0";
  bool _isDarkTheme = false;

  void _onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        _output = "0";
      } else if (buttonText == "⌦") {
        _output =
            _output.length > 1 ? _output.substring(0, _output.length - 1) : "0";
      } else if (buttonText == "=") {
        _calculateResult();
      } else if (buttonText == "%") {
        _output = (double.parse(_output) / 100).toString();
      } else if (buttonText == "π") {
        _output = pi.toString();
      } else if (buttonText == "ln") {
        double num = double.parse(_output);
        if (num > 0) {
          _output = (log(num)).toString();
        } else {
          _output = "Ошибка";
        }
      } else {
        if (_output == "0" && buttonText != ".") {
          _output = buttonText;
        } else {
          _output += buttonText;
        }
      }
    });
  }

  void _calculateResult() {
    try {
      Parser p = Parser();
      Expression exp =
          p.parse(_output.replaceAll('×', '*').replaceAll('÷', '/'));
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      setState(() {
        _output = eval.toString();
      });
    } catch (e) {
      setState(() {
        _output = "Ошибка";
      });
    }
  }

  void _toggleTheme() {
    setState(() {
      _isDarkTheme = !_isDarkTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Калькулятор"),
        actions: [
          IconButton(
            icon: Icon(_isDarkTheme ? Icons.light_mode : Icons.dark_mode),
            onPressed: _toggleTheme,
          ),
        ],
      ),
      body: Container(
        color: _isDarkTheme ? Color(0xFF040110) : Color(0xFFD29E0D), // Фон
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(20),
                alignment: Alignment.bottomRight,
                child: Text(
                  _output,
                  style: TextStyle(
                    fontSize: 48,
                    color: Colors.white, // Белый текст
                  ),
                ),
              ),
            ),
            Divider(height: 1),
            Expanded(
              flex: 2,
              child: GridView.count(
                crossAxisCount: 4,
                padding: EdgeInsets.all(10),
                children: [
                  _buildButton("⌦", isRed: true), // Красная кнопка
                  _buildButton("%"),
                  _buildButton("="),
                  _buildButton("×"),
                  _buildButton("7"),
                  _buildButton("8"),
                  _buildButton("9"),
                  _buildButton("-"),
                  _buildButton("4"),
                  _buildButton("5"),
                  _buildButton("6"),
                  _buildButton("+"),
                  _buildButton("1"),
                  _buildButton("2"),
                  _buildButton("3"),
                  _buildButton("π"),
                  _buildButton("0"),
                  _buildButton("."),
                  _buildButton("ln"),
                  _buildButton("÷"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String buttonText, {bool isRed = false}) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isRed
              ? Colors.red // Красная кнопка для "⌦"
              : _isDarkTheme
                  ? Color(0xFF182132) // Цвет кнопок в тёмной теме
                  : Color(0xFF714D00), // Цвет кнопок в светлой теме
          foregroundColor: Colors.white, // Белый текст на кнопках
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(
              color: _isDarkTheme ? Colors.transparent : Colors.white,
              width: 2,
            ),
          ),
          padding: EdgeInsets.all(20),
        ),
        onPressed: () => _onButtonPressed(buttonText),
        child: Text(
          buttonText,
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
