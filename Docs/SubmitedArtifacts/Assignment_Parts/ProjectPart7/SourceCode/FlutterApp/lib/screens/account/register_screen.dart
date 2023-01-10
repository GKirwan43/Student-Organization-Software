import 'package:Student_Organization_Software/screens/account/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:Student_Organization_Software/widgets/log_in_style/text_field.dart';
import 'package:Student_Organization_Software/widgets/log_in_style/button.dart';

// text controllers for the text fields
TextEditingController emailTextController = TextEditingController();
TextEditingController usernameTextController = TextEditingController();
TextEditingController passwordTextController = TextEditingController();

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const SafeArea(
        child: Center(
          child: RegisterForm(),
        ),
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State createState() => _RegisterForm();
}

class _RegisterForm extends State<RegisterForm> {
  final _RegisterFormKey = GlobalKey<FormState>();
  String isValid = "";

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _RegisterFormKey,
      child: Column(
        children: [
          const SizedBox(height: 150),

          // Create an Account
          const Text(
            "Create an Account",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          const SizedBox(height: 50),

          // email textfield
          LogInTextField(
            type: TextFieldType.email,
            textController: emailTextController,
          ),
          const SizedBox(height: 10),

            // username textfield
          LogInTextField(
            type: TextFieldType.username,
            textController: usernameTextController,
          ),
          const SizedBox(height: 10),

          // password textfield
          LogInTextField(
            type: TextFieldType.password,
            textController: passwordTextController,
          ),
          const SizedBox(height: 10),

          // error message
          Text(
            isValid,
            style: const TextStyle(
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 10),

          // register button
          LogInButton(
            text: "Create Account",
            onPressed: () => {
              // check valid creds
              if (!emailTextController.text.contains('@')) {
                setState( () => {
                  isValid = "Invalid email"
                })
              } else if (usernameTextController.text.length < 6) {
                setState(() => {
                  isValid = "Username must be 6 or more characters long"
                })
              }
              else if (passwordTextController.text.length < 6) {
                setState(() => {
                  isValid = "Password must be 6 or more characters long"
                })
              } else {
              // push account info to database
              // if successful return to welcome screen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen()
                ),
              )
              }

            }
          ),

          const SizedBox(height: 10),

          // register
          Row(
            mainAxisAlignment: MainAxisAlignment.center, // centers row horizontally
            children: [
              const Text(
                "Already have an account? ",
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen()),
                  );
                },
                child: const Text("Log in here!"),
              ),
            ],
          ),
        ]
      ),
    );
  }
}