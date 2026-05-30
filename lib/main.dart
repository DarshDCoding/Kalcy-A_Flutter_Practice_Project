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


    final colors = {
      "dark": const Color.fromRGBO(54, 59, 81, 1.0),
      "light": const Color.fromRGBO(255, 255, 255, 1.0),
      "operatorsColor": const Color.fromARGB(255, 175, 1, 1),
    };
    Container buttonBody ({
      required String sign,
      required String type,
      required bool isDark,
      String? borderSide,
    }){
      return Container(
        decoration: BoxDecoration(
          // border:  
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(sign, style: TextStyle(
            color: type == "operator"? colors["operatorsColor"]: isDark ? colors["light"]: colors["dark"],
            fontSize: 40
          ),),
        ),
      );
    }

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    final isDark = brightness == Brightness.dark;

    final buttons = [
      //row 1
      TextButton(onPressed: (){removeAllChar();}, child: buttonBody(sign: "C", type: "operator", isDark: isDark)),
      TextButton(onPressed: (){changeSign();}, child: buttonBody(sign: "+/-", type: "operator", isDark: isDark)),
      TextButton(onPressed: (){calPercentage(_displayText);}, child: buttonBody(sign: "%", type: "operator", isDark: isDark)),
      TextButton(onPressed: (){addOperator("\u00F7");}, child: buttonBody(sign: "\u00F7", type: "operator", isDark: isDark)),

      //row 2
      TextButton(onPressed: (){addChar("7");}, child: buttonBody(sign: "7", type: "number", isDark: isDark)),
      TextButton(onPressed: (){addChar("8");}, child: buttonBody(sign: "8", type: "number", isDark: isDark)),
      TextButton(onPressed: (){addChar("9");}, child: buttonBody(sign: "9", type: "number", isDark: isDark)),
      TextButton(onPressed: (){addOperator("x");}, child: buttonBody(sign: "x", type: "operator", isDark: isDark)),

      //row 3
      TextButton(onPressed: (){addChar("4");}, child: buttonBody(sign: "4", type: "number", isDark: isDark)),
      TextButton(onPressed: (){addChar("5");}, child: buttonBody(sign: "5", type: "number", isDark: isDark)),
      TextButton(onPressed: (){addChar("6");}, child: buttonBody(sign: "6", type: "number", isDark: isDark)),
      TextButton(onPressed: (){addOperator("-");}, child: buttonBody(sign: "-", type: "operator", isDark: isDark)),

      //row 4
      TextButton(onPressed: (){addChar("1");}, child: buttonBody(sign: "1", type: "number", isDark: isDark)),
      TextButton(onPressed: (){addChar("2");}, child: buttonBody(sign: "2", type: "number", isDark: isDark)),
      TextButton(onPressed: (){addChar("3");}, child: buttonBody(sign: "3", type: "number", isDark: isDark)),
      TextButton(onPressed: (){addOperator("+");}, child: buttonBody(sign: "+", type: "operator", isDark: isDark)),

      //row 5
      TextButton(onPressed: (){addChar("0");}, child: buttonBody(sign: "0", type: "number", isDark: isDark)),
      TextButton(onPressed: (){addDecimal(_displayText);}, child: buttonBody(sign: ".", type: "number", isDark: isDark)),
      SizedBox(width: 50,),
      TextButton(onPressed: (){calValue(_displayText);}, child: Container(
        // width: 500,
        decoration: BoxDecoration(
          // color: Colors.green,
        ),
        child: Text("=", style: TextStyle(
          color: colors["operatorsColor"],
          fontSize: 40
          ),
        ),
      ),
      )
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: isDark? colors["dark"]: colors["light"],
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Align(
                  alignment: AlignmentGeometry.bottomRight,
                  child: Text(_displayText, style: TextStyle(
                    fontSize: 62,
                    fontWeight: FontWeight(600),
                    color: isDark? colors["light"]: colors["dark"],
                  ),),
                ),
              )),
            Expanded(
              flex: 7,
              child:GridView.builder(
                itemCount: buttons.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
                itemBuilder: (context, index) {
                  return buttons[index];
                },
                ))
          ],
        ),
      ),
    );
  }
}