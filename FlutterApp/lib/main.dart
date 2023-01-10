import 'package:Student_Organization_Software/screens/account/login_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const SOS());
}

class SOS extends StatelessWidget {
  const SOS({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          // Define the default brightness and colors.
          primarySwatch: Colors.blue,

          // Define the default font family.
          fontFamily: 'Roboto',

          // Define the default `TextTheme`. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme: const TextTheme(
            headline1: TextStyle(
                fontSize: 25, color: Colors.white, fontWeight: FontWeight.w500),
            headline2: TextStyle(
                fontSize: 25, color: Colors.white, fontWeight: FontWeight.w500),
            headline3: TextStyle(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500),
            bodyText1: TextStyle(
                fontSize: 25, color: Colors.grey, fontWeight: FontWeight.w500),
            bodyText2: TextStyle(
                fontSize: 15, color: Colors.grey, fontWeight: FontWeight.w500),
          ),
        ),
        home: const LoginScreen());
  }
}
