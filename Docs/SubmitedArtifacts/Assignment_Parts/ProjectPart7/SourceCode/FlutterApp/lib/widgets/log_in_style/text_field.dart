import 'package:flutter/material.dart';

enum TextFieldType {
  email,
  username,
  password,
}

class LogInTextField extends StatelessWidget {
  const LogInTextField(
      {Key? key, required this.type, required this.textController})
      : super(key: key);

  final TextFieldType type;
  final TextEditingController textController;

  @override
  Widget build(BuildContext context) {
    return (SizedBox(
      width: 250,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[350],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextFormField(
            controller: textController,
            keyboardType: // responsive keyboard
              type == TextFieldType.email ? 
              TextInputType.emailAddress : (
                type == TextFieldType.username ? 
                TextInputType.name : 
                TextInputType.visiblePassword
              ),
            obscureText: type == TextFieldType.password,
            cursorColor: Colors.grey[700],
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: type == TextFieldType.email
                  ? "Email"
                  : (type == TextFieldType.username ? "Username" : "Password"),
              hintStyle: TextStyle(
                color: Colors.grey[700],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
