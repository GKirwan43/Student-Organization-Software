import 'package:Student_Organization_Software/data/functions.dart' as functions;
import 'package:Student_Organization_Software/data/reusable_strings.dart'
    as strings;
import 'package:weekday_selector/weekday_selector.dart';
import 'package:flutter/material.dart';

import 'invalid_time.dart';

pickDays(context) async {
  List<List<int>>? confirmedValues = [];

  await showDialog(
      context: context,
      builder: (BuildContext context) {
        List<List<int>>? arrayValues = [];
        List<bool>? values = List.filled(7, false);
        return StatefulBuilder(builder: (context, StateSetter setState) {
          return AlertDialog(
            title: const Text('Select meeting days'),
            content: WeekdaySelector(
              onChanged: (int day) async {
                final index = day % 7;

                if (values[index] == false) {
                  TimeOfDay? pickedStartTime =
                      await functions.askTime(context, "Enter start time");

                  if (pickedStartTime != null) {
                    TimeOfDay? pickedEndTime =
                        await functions.askTime(context, "Enter end time");

                    double sTime =
                        pickedStartTime.hour + pickedStartTime.minute / 60;
                    double eTime = pickedEndTime != null
                        ? pickedEndTime.hour + pickedEndTime.minute / 60
                        : -1;
                    if (eTime != -1) {
                      if (eTime >= sTime) {
                        if (pickedEndTime != null) {
                          arrayValues.add([
                            index == 0 ? 7 : index,
                            pickedStartTime.hour,
                            pickedStartTime.minute,
                            pickedEndTime.hour,
                            pickedEndTime.minute
                          ]);

                          setState(() => values[index] = !values[index]);
                        }
                      } else {
                        // ignore: use_build_context_synchronously
                        invalidTimePopup(context);
                      }
                    }
                  }
                } else {
                  setState(() => values[index] = false);
                  for (int i = 0; i < arrayValues.length; i++) {
                    if (arrayValues[i][0] == (index == 0 ? 7 : index)) {
                      arrayValues.removeAt(i);
                    }
                  }
                }
              },
              values: values,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(strings.cancel),
              ),
              TextButton(
                onPressed: () {
                  confirmedValues = arrayValues;
                  Navigator.pop(context);
                },
                child: Text(strings.submit),
              ),
            ],
          );
        });
      });

  return confirmedValues;
}
