import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class CalcScreen extends StatefulWidget {
  const CalcScreen({super.key});
  @override
  State<CalcScreen> createState() => _CalcScreenState();
}

class _CalcScreenState extends State<CalcScreen> {
  String equation = "0";
  String result = "0";
  String expression = "";

  void buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        equation = "0";
        result = "0";
      } else if (buttonText == "⌫") {
        equation = equation.substring(0, equation.length - 1);
        if (equation == "") {
          equation = "0";
        }
      } else if (buttonText == "=") {
        expression = equation;
        expression = expression.replaceAll('×', '*');
        expression = expression.replaceAll('÷', '/');
        try {
          Parser p = Parser();
          Expression exp = p.parse(expression);
          ContextModel cm = ContextModel();
          double eval = exp.evaluate(EvaluationType.REAL, cm);
          result = '${eval % 1 == 0 ? eval.toInt() : eval}';
        } catch (e) {
          result = "Error";
        }
      } else {
        if (equation == "0") {
          equation = buttonText;
        } else {
          equation = equation + buttonText;
        }
      }
    });
  }

  //INIT: NUEVA IMPLEMENTACION
  Widget buildKeyboard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          buildRow(["C", "⌫", "%", "÷"], isOperator: true),
          buildRow(["7", "8", "9", "×"]),
          buildRow(["4", "5", "6", "-"]),
          buildRow(["1", "2", "3", "+"]),
          buildRow(["+/-", "0", ".", "="], lastRow: true),
        ],
      ),
    );
  }

  Widget buildRow(
    List<String> texts, {
    bool isOperator = false,
    bool lastRow = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: texts.map((text) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: buildCalcButton(text),
          ),
        );
      }).toList(),
    );
  }

  Widget buildCalcButton(String text) {
    bool isAction = [
      "C",
      "⌫",
      "%",
      "÷",
      "×",
      "-",
      "+",
      "=",
      "+/-",
    ].contains(text);
    bool isEqual = text == "=";
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(20.0),
        backgroundColor: isEqual
            ? Colors.blueAccent
            : (isAction ? Colors.grey[200]! : Colors.white),
        foregroundColor: isEqual
            ? Colors.white
            : (isAction ? Colors.blueAccent : Colors.black87),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(18.0),
        ),
        elevation: 0,
      ),
      onPressed: () => buttonPressed(text),
      child: Text(
        text,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }
  //END: NUEVA IMPLEMENTACION

  Widget buildButton(String buttonText, Color textColor, Color buttonColor) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: textColor,
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 2,
        ),
        onPressed: () => buttonPressed(buttonText),
        child: Text(
          buttonText,
          style: const TextStyle(fontSize: 26.0, fontWeight: FontWeight.normal),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 10),
              child: Text(
                equation,
                style: const TextStyle(fontSize: 30.0, color: Colors.black54),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.fromLTRB(20, 1, 20, 20),
              child: Text(
                result,
                style: const TextStyle(
                  fontSize: 55.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const Spacer(),
            buildKeyboard(),
          ],
        ),
      ),
    );
  }
}
