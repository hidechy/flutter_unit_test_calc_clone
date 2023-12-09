import 'package:flutter/material.dart';

import '../constants.dart';

typedef FunctionOnPressed = void Function(String text);

class Button extends StatelessWidget {

  Button(this.text, this.colorButton, this.colorText, this.onPressed) : super(key: Key(text));
  final String text;
  final Color colorButton;
  final Color colorText;

  final FunctionOnPressed? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: ElevatedButton(
          onPressed: () {
            onPressed!(text);
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: colorText, backgroundColor: colorButton,
            shape: text == '0' ? const StadiumBorder() : const CircleBorder(),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: mapIcon.containsKey(text)
                ? Icon(
                    mapIcon[text],
                    size: 15,
                  )
                : Text(
                    text,
                    style: const TextStyle(fontSize: 15),
                  ),
          ),
        ));
  }
}
