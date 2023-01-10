import 'package:flutter/material.dart';

class LogInButton extends StatelessWidget {
  const LogInButton({Key? key, required this.text, required this.onPressed})
      : super(key: key);

  final String text;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return (
      SizedBox(
        height: 40,
        width: 250,
        child: TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.hovered)) {
                return Colors.grey[200];
              } else {
                return Colors.blue;
              }
            }),
            foregroundColor: MaterialStateProperty.resolveWith(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.hovered)) {
                return Colors.blue;
              } else {
                return Colors.grey[200];
              }
            }),
          ),
          onPressed: onPressed,
          child: Text(text)
        ),
      )
    );
  }
}
