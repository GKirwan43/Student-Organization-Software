import 'package:Student_Organization_Software/data/backend_access.dart';
import 'package:Student_Organization_Software/screens/account/register_screen.dart';
import 'package:Student_Organization_Software/skaffolds/home_skaffold.dart';
import 'package:flutter/material.dart';
import 'package:Student_Organization_Software/widgets/log_in_style/text_field.dart';
import 'package:Student_Organization_Software/widgets/log_in_style/button.dart';
import 'package:Student_Organization_Software/data/transitions.dart'
    as transitions;
import '../../widgets/popups/loading_wheel.dart';
import '../../widgets/popups/error.dart';

// text controllers for the text fields
TextEditingController usernameTextController = TextEditingController();
TextEditingController passwordTextController = TextEditingController();

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: const SafeArea(
            child: Center(
          child: LoginForm(),
        )));
  }
}

// form stuff
class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State createState() => _LoginForm();
}

class _LoginForm extends State<LoginForm> {
  final _logInFormKey = GlobalKey<FormState>();
  String isValid = "";

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _logInFormKey,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        // greeting
        const Text(
          "Welcome back!",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        const SizedBox(height: 40),

        // username/email textfield
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

        // log in button
        LogInButton(
            text: "Log In",
            onPressed: () async {
              setState(() {
                isValid = "";
              });

              Navigator.push(context, transitions.fade(const LoadingWheel()));

              try {
                final response = await login(
                    usernameTextController.text, passwordTextController.text);
                int statusCode = response; //Replace with response.statusCode

                // ignore: use_build_context_synchronously
                Navigator.pop(context);

                if (statusCode == 200) {
                  // ignore: use_build_context_synchronously
                  Navigator.push(
                      context, transitions.fade(const HomeSkaffold()));
                } else if (statusCode == 401) {
                  setState(() {
                    isValid = "Incorrect username or password";
                  });
                } else {
                  // ignore: use_build_context_synchronously
                  errorPopup(context, statusCode);
                }
              } catch (_) {
                Navigator.pop(context);
                errorPopup(context, 0);
              }
            }),

        const SizedBox(height: 10),

        // register
        Row(
          mainAxisAlignment:
              MainAxisAlignment.center, // centers row horizontally
          children: [
            const Text(
              "Not a member? ",
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  transitions.fade(const RegisterScreen()),
                );
              },
              child: const Text("Register here!"),
            ),
          ],
        ),
      ]),
    );
  }
}
