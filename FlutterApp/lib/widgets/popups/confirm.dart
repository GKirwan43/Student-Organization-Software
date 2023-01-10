import 'package:Student_Organization_Software/data/reusable_strings.dart'
    as strings;
import 'package:flutter/material.dart';

confirmPopup(context) async {
  bool save = false;

  await showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text(strings.unsavedNote),
      content: Text(strings.saveNoteQuestion),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(strings.cancel),
        ),
        TextButton(
          onPressed: () {
            save = true;
            Navigator.pop(context);
          },
          child: Text(strings.save),
        ),
      ],
    ),
  );

  return save;
}
