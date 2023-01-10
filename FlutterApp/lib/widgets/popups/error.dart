import 'package:Student_Organization_Software/data/reusable_strings.dart'
    as strings;
import 'package:flutter/material.dart';

errorPopup(context, statusCode) {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('An error occured'),
      content: Text(strings.getError(statusCode)),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Ok'),
          child: const Text('Ok'),
        ),
      ],
    ),
  );
}
