import 'dart:ffi';
import 'dart:nativewrappers/_internal/vm/lib/internal_patch.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(Kalcy());
}

class Kalcy extends StatefulWidget {
  const Kalcy({super.key});

  @override
  State<Kalcy> createState() => _KalcyState();
}

class _KalcyState extends State<Kalcy> {
  String _displayText = "";
  final List<String> _operations = ["+", "-", "x", "\u00F7"];

  void addChar(String char) {
    setState(() {
      _displayText += char;
    });
  }

  void removeChar(String char) {
    int textLength = _displayText.length;
    setState(() {
      _displayText = textLength > 0
          ? _displayText.substring(0, textLength - 1)
          : _displayText;
    });
  }

  void removeAllChar() {
    setState(() {
      _displayText = "";
    });
  }

  void changeSign() {
    setState(() {
      if (!checkExpression().isExpression) {
        _displayText = _displayText.startsWith("-")
            ? _displayText.substring(1)
            : "-$_displayText";
      }
    });
  }

  ({bool isExpression, String operation, int val1, int val2}) checkExpression(String displayText) {
    bool isExpression = false;
    String operation = '';
    int val1 = 0;
    int val2 = 0;

    for (final operator in _operations) {
      if (displayText.contains(operator)) {
        isExpression = true;
        operation = operator;
      }
    }

    if (isExpression){
      List<String> inputVals = displayText.split(operation);
      val1 = int.parse(inputVals[0]);
      val2 = int.parse(inputVals[1]);
    }
    return (isExpression: isExpression, operation: operation, val1: val1, val2: val2);
  }

  String calValue(String displayText) {
    String value = "";
    bool isExpression = checkExpression(_displayText).isExpression;

    if (isExpression) {
      int input1 = checkExpression(_displayText).val1;
      int input2 = checkExpression(_displayText).val2;

      switch (checkExpression(_displayText).operation) {
        case "+":
          value = (input1 + input2).toString();
          break;

        case "-":
          value = (input1 - input2).toString();
          break;

        case "x":
          value = (input1 * input2).toString();
          break;

        case "\u00F7":
          value = input2 == 0 ? "Chutiya" : (input1 / input2).toString();
          break;
      }
    }
    return value;
  }
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red, width: 2),
                ),
                child: Expanded(
                  child: Align(
                    alignment: AlignmentGeometry.bottomRight,
                    child: Text(_displayText, style: TextStyle(fontSize: 20)),
                  ),
                ),
              ),
              TextButton(onPressed: () {}, child: Text("1")),
            ],
          ),
        ),
      ),
    );
  }
}
