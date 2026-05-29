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
  bool _isSigned = false;
  bool _addedDecimal = false;

  void addChar(String char) {
    clearBeChutiye();
    setState(() {
      _displayText += char;
    });
  }

  int addOperator(String operator) {

    if (clearBeChutiye()){
      return -1;
    }

    if (_displayText.isEmpty){
      return -1;
    }

    _isSigned = false;
    _addedDecimal = false;

    String lastLetter = _displayText.isNotEmpty
        ? _displayText[_displayText.length - 1]
        : "";

    if (_operations.contains(lastLetter)) {
      setState(() {
        _displayText =
            _displayText.substring(0, _displayText.length - 1) + operator;
      });
    } else {
      if (checkExpression(_displayText).isExpression) {
        calValue(_displayText);
      }
      setState(() {
        _displayText += operator;
      });
    }
    return 1;
  }
  //TODO: remove entire text if text is "Be Chutiye". --done by creating a clearBeChutiye function and using it on every buttons click.

  bool clearBeChutiye() {
    bool isCleared = false;
    
    if (_displayText == "Be Chutiye") {
      setState(() {
        _displayText = "";
      });
      isCleared = true;
    }

    return isCleared;
  }

  void removeChar() {
    clearBeChutiye();

    int textLength = _displayText.length;
    
    setState(() {
      _displayText = textLength > 0
          ? _displayText.substring(0, textLength - 1)
          : _displayText;
    });
  }

  void removeAllChar() {
    _addedDecimal = false;

    setState(() {
      _displayText = "";
    });
  }

  int changeSign() {
    clearBeChutiye();
    
    if (checkExpression(_displayText).isExpression){
      return -1;
    }

    if (!_isSigned) {
      setState(() {
        _displayText += "-";
      });
      _isSigned = true;
    }
    return 1;
  }

  void addDecimal (String displayText){

    if (!_addedDecimal){
      setState(() {
        _displayText += ".";
      });
      _addedDecimal = true;
    }

  }

  ({bool isExpression, String operation, num val1, num val2}) checkExpression(
    String displayText,
  ) {
    bool isExpression = false;
    String operation = '';
    num val1 = 0;
    num val2 = 0;

    final regex = RegExp(r'^(-?\d*\.?\d+)([+\-x\u00F7])(-?\d*\.?\d+)');

    final match = regex.firstMatch(displayText);

    if (match != null) {
      isExpression = true;
      operation = match.group(2)!;
      val1 = num.parse(match.group(1)!);
      val2 = num.parse(match.group(3)!);
    }

    return (
      isExpression: isExpression,
      operation: operation,
      val1: val1,
      val2: val2,
    );
  }

  String numFormatter (num number){
    return number.toStringAsFixed(5).replaceFirst(RegExp(r'\.?0+$'), "");
  }

  String calValue(String displayText) {
    clearBeChutiye();

    _isSigned = false;

    String value = "";
    bool isExpression = checkExpression(displayText).isExpression;

    if (isExpression) {
      num input1 = checkExpression(displayText).val1;
      num input2 = checkExpression(displayText).val2;

      switch (checkExpression(displayText).operation) {
        case "+":
          value = numFormatter((input1 + input2));
          break;

        case "-":
          value = numFormatter((input1 - input2));
          break;

        case "x":
          value = numFormatter((input1 * input2));
          break;

        case "\u00F7":
          if (input2 == 0) {
            value = "Be Chutiye";
            break;
          }
          value = numFormatter(input1/input2);
          break;
      }
      setState(() {
        _displayText = value;
      });
    } else {}
    return value;
  }

  void calPercentage(String displayText) {
    clearBeChutiye();

    final expression = checkExpression(displayText);
    num input1 = expression.val1;
    num input2 = expression.val2;

    double intermediateInput2 = 0;
    double percent = 0;
    String operator = expression.operation;

    if (expression.isExpression) {
      intermediateInput2 = input2 / 100;
      percent = input1 * intermediateInput2;

      calValue("$input1$operator$percent");
    }
  }
  //TODO: make percentange calculation better and calculate 121 + 10%. Expected: 133.1 , Current 131. --done by using num insted of int and
  // updating regex to take decimal values.

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
                alignment: Alignment.bottomRight,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red, width: 2),
                ),
                child: SingleChildScrollView(
                  reverse: false,
                  child: Text(_displayText, style: TextStyle(fontSize: 20)),
                ),
              ),

              Column(
                children: [
                  TextButton(
                    onPressed: () {
                      addDecimal(_displayText);
                    },
                    child: Text(".", style: TextStyle(fontSize: 24)),
                  ),
                  TextButton(
                    onPressed: () {
                      addChar("0");
                    },
                    child: Text("0", style: TextStyle(fontSize: 24)),
                  ),
                  TextButton(
                    onPressed: () {
                      addChar("1");
                    },
                    child: Text("1", style: TextStyle(fontSize: 24)),
                  ),

                  TextButton(
                    onPressed: () {
                      addChar("2");
                    },
                    child: Text("2", style: TextStyle(fontSize: 24)),
                  ),
                  TextButton(
                    onPressed: () {
                      addOperator("+");
                    },
                    child: Text("+", style: TextStyle(fontSize: 24)),
                  ),
                  TextButton(
                    onPressed: () {
                      addOperator("-");
                    },
                    child: Text("-", style: TextStyle(fontSize: 24)),
                  ),

                  TextButton(
                    onPressed: () {
                      addOperator("x");
                    },
                    child: Text("X", style: TextStyle(fontSize: 24)),
                  ),

                  TextButton(
                    onPressed: () {
                      addOperator("\u00F7");
                    },
                    child: Text("\u00F7", style: TextStyle(fontSize: 24)),
                  ),
                  TextButton(
                    onPressed: () {
                      calPercentage(_displayText);
                    },
                    child: Text("%", style: TextStyle(fontSize: 24)),
                  ),

                  TextButton(
                    onPressed: () {
                      print(checkExpression(_displayText));
                      calValue(_displayText);
                    },
                    child: Text("=", style: TextStyle(fontSize: 24)),
                  ),

                  TextButton(
                    onPressed: () {
                      removeChar();
                    },
                    child: Text("C", style: TextStyle(fontSize: 24)),
                  ),

                  TextButton(
                    onPressed: () {
                      removeAllChar();
                    },
                    child: Text("CE", style: TextStyle(fontSize: 24)),
                  ),

                  TextButton(
                    onPressed: () {
                      changeSign();
                    },
                    child: Text("+/-", style: TextStyle(fontSize: 24)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
