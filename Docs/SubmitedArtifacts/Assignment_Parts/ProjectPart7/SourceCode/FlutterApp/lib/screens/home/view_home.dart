import 'package:Student_Organization_Software/data/backend_access.dart' as data;
import 'package:flutter/material.dart';

class ViewHome extends StatelessWidget {
  const ViewHome({super.key});

  @override
  Widget build(BuildContext context) {
    String username = data.user.username;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Welcome back $username!",
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Text(
              "Put relevant information here.",
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ],
        ),
      ),
    );
  }
}
