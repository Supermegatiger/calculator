import 'dart:io';
import 'package:flutter/material.dart';
import 'buttonPanel.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'package:flutter/services.dart';
import 'package:function_tree/function_tree.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CalcPage extends StatefulWidget {
  const CalcPage({super.key});

  @override
  State<CalcPage> createState() => _CalcPageState();
}

class _CalcPageState extends State<CalcPage> {
  String expression = '';
  String operand = '0';
  String res = '';
  var parCount = 0;

  void changeOperand(int i) {
    setState(() {
      if (operand != '0') {
        operand += i.toString();
      } else {
        operand = i.toString();
      }
    });
  }

  void clear([bool all = false]) {
    setState(() {
      if (all) {
        expression = '';
        parCount = 0;
      }
      operand = '0';
    });
  }

  void erase() {
    setState(() {
      if (operand.length > 1) {
        operand = operand.substring(0, operand.length - 1);
      } else {
        operand = '0';
      }
    });
  }

  void action(String op) {
    setState(() {
      if (operand != '') {
        expression += operand;
        tryEval();
        expression += " $op ";
        operand = '';
      } else if (expression != '' && expression[expression.length - 1] == ')') {
        expression += " $op ";
      } else if (expression != '') {
        expression = "${expression.substring(0, expression.length - 2)}$op ";
      }
    });
  }

  void tryEval() {
    setState(() {
      try {
        eval();
      } catch (er) {
        res = '0';
      }
    });
  }

  void sqrtOp() {
    setState(() {
      if (operand != '') {
        operand = 'sqrt($operand)';
        action('+');
      }
    });
  }

  void eval() {
    setState(() {
      var t = expression
          .replaceAll(RegExp(r'x'), '*')
          .replaceAll(RegExp(r'÷'), '/');
      print(t);
      res = t.interpret().toDouble().toString();
      var l = res.length;
      if (l > 2 && res[l - 2] == '.' && res[l - 1] == '0') {
        res = res.substring(0, l - 2);
      }
    });
  }

  void makeDecim() {
    setState(() {
      if (!operand.contains('.')) {
        if (operand != '') {
          operand += '.';
        } else {
          operand += '0.';
        }
      }
    });
  }

  void leftParenthesis() {
    setState(() {
      if (expression == '' || expression[expression.length - 1] != ')') {
        expression += '( ';
        parCount++;
      }
    });
  }

  void rightParenthesis() {
    setState(() {
      if (parCount > 0 && operand != '') {
        expression += '$operand )';
        tryEval();
        operand = '';
        if (expression[expression.length - 4] == '(') {
          expression = expression.substring(0, expression.length - 4);
        }
        parCount--;
      }
    });
  }

  bool isMobile() {
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> tryCopy() async {
    try {
      await Clipboard.setData(
          ClipboardData(text: operand == '' ? res : operand));
      if (isMobile()) {
        Fluttertoast.showToast(
          msg: "Скопировано",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            duration: Duration(milliseconds: 1000),
            content: Center(
                child: Text(
              "Скопировано",
              style: TextStyle(color: Theme.of(context).hintColor),
            )),
          ),
        );
      }
    } catch (er) {}
  }

  bool _isNumeric(String? str) {
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }

  Future<void> tryPaste() async {
    try {
      Clipboard.getData(Clipboard.kTextPlain).then((value) {
        if (_isNumeric(value?.text)) {
          setState(() {
            operand = (value?.text)!;
          });
        } else {
          if (isMobile()) {
            Fluttertoast.showToast(
              msg: "В буфере обмена не число",
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: 1,
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor:
                    Theme.of(context).colorScheme.secondaryContainer,
                duration: Duration(milliseconds: 1000),
                content: Center(
                    child: Text(
                  "В буфере обмена не число",
                  style: TextStyle(color: Theme.of(context).hintColor),
                )),
              ),
            );
          }
        }
      });
    } catch (er) {}
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 26);
    var col = Colors.black12;
    var appState = context.watch<MyAppState>();
    void getAnswer() {
      setState(() {
        if (operand == '' && expression[expression.length - 1] != ')') {
          expression = expression.substring(0, expression.length - 2);
        }
        expression += operand;
        if (parCount != 0) {
          expression += ")" * parCount;
        }
        tryEval();
        appState.pushRes(expression, res);
        operand = '';
        expression = '';
      });
    }

    void keyPressed(String val) {
      if (val.split(" ")[0] == "Numpad") val = val.split(" ")[1];
      if (['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'].contains(val)) {
        changeOperand(int.parse(val));
      } else {
        switch (val) {
          case "(":
            leftParenthesis();
            break;
          case ")":
            rightParenthesis();
            break;
          case "Backspace":
            erase();
            break;
          case "CE":
          case "Delete":
            clear();
            break;
          case "C":
          case "Escape":
            clear(true);
            break;
          case "+":
          case "Add":
            action('+');
            break;
          case "x²":
            action('^');
            setState(() {
              operand = '2';
            });
            break;
          case "xʸ":
          case "^":
            action('^');
            break;
          case "x!":
            setState(() {
              operand += '!';
            });
            action('+');
            break;
          case "-":
          case "Subtract":
            action('-');
            break;
          case 'x':
          case '*':
          case "Multiply":
            action('x');
            break;
          case '√':
            sqrtOp();
            break;
          case '%':
            action('%');
            break;
          case '÷':
          case '/':
          case "Divide":
            action('÷');
            break;
          case "=":
          case "Enter":
            if (expression != '') getAnswer();
            break;
          case ',':
            makeDecim();
            break;
          default:
            break;
        }
      }
    }

    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (event) {
        if (event is RawKeyDownEvent) {
          keyPressed(event.logicalKey.keyLabel);
        }
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Padding(
                      child: Text(expression),
                      padding: EdgeInsets.all(3.0),
                    ),
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: GestureDetector(
                            onLongPress: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    height: 100,
                                    child: Center(
                                      child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.black38,
                                              ),
                                              onPressed: () {
                                                tryCopy();
                                                Navigator.pop(context);
                                              },
                                              child: Text('Копировать'),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.black38,
                                                ),
                                                onPressed: () {
                                                  tryPaste();
                                                  Navigator.pop(context);
                                                },
                                                child: Text('Вставить')),
                                          ]),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Text(
                              operand == '' ? res : operand,
                              textAlign: TextAlign.end,
                              textScaleFactor: 3,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ButtonPanel(
                textStyle: textStyle,
                col: col,
                onPressed: (value) => keyPressed(value.toString()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
