import 'package:flutter/material.dart';

class NullText extends StatelessWidget {
  const NullText({super.key, required this.text, required this.description});

  final String text;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            text,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ],
      ),
    );
  }
}
