import 'package:flutter/material.dart';
import 'package:flutter_grid_button/flutter_grid_button.dart';

class ButtonPanel extends StatelessWidget {
  const ButtonPanel({
    super.key,
    required this.textStyle,
    required this.col,
    required this.onPressed,
  });

  final TextStyle textStyle;
  final Color col;
  final void Function(dynamic) onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridButton(
        textStyle: textStyle,
        borderColor: Colors.black,
        borderWidth: 0,
        onPressed: onPressed,
        // ignore: todo
        // TODO добавить скобки, функции, степени
        items: [
          [
            GridButtonItem(title: "CE", color: col),
            GridButtonItem(title: "C", color: col),
            GridButtonItem(
              title: "Backspace",
              child: Icon(Icons.backspace),
              color: col,
            ),
            GridButtonItem(title: "%", color: col),
            GridButtonItem(title: "÷", color: col),
          ],
          [
            GridButtonItem(title: "xʸ"),
            GridButtonItem(title: "7"),
            GridButtonItem(title: "8"),
            GridButtonItem(title: "9"),
            GridButtonItem(title: "x", color: col),
          ],
          [
            GridButtonItem(title: "x²"),
            GridButtonItem(title: "4"),
            GridButtonItem(title: "5"),
            GridButtonItem(title: "6"),
            GridButtonItem(title: "-", color: col),
          ],
          [
            GridButtonItem(title: "√"),
            GridButtonItem(title: "1"),
            GridButtonItem(title: "2"),
            GridButtonItem(title: "3"),
            GridButtonItem(title: "+", color: col),
          ],
          [
            GridButtonItem(title: "("),
            GridButtonItem(title: ")"),
            GridButtonItem(title: "0"),
            GridButtonItem(title: ","),
            GridButtonItem(title: "=", color: col),
          ],
        ],
      ),
    );
  }
}
