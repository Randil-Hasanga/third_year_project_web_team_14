import 'package:flutter/material.dart';

class ButtonWidgets {

  ButtonWidgets();

  Widget simpleElevatedButtonWidget({
  VoidCallback? onPressed,
  ButtonStyle? style,
  String? buttonText,
}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: style ?? ElevatedButton.styleFrom(
      backgroundColor: Color.fromARGB(255, 255, 181, 120),
    ),
    child: Text("$buttonText", style: TextStyle(
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    ),),
  );
}

}
