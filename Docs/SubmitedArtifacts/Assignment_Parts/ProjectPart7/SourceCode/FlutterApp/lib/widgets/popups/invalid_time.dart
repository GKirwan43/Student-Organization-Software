import 'package:Student_Organization_Software/data/reusable_strings.dart'
    as strings;
import 'package:flutter/material.dart';

invalidTimePopup(context) {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text(strings.invalidTime),
      content: Text(strings.timeError),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Ok'),
          child: const Text('Ok'),
        ),
      ],
    ),
  );
}
