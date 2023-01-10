import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../widgets/popups/loading_wheel.dart';
import '../../widgets/popups/error.dart';
import 'package:Student_Organization_Software/data/transitions.dart'
    as transitions;
import 'package:Student_Organization_Software/data/backend_access.dart';

// Put functions that are called multiple times within the app here.

List<Color> courseColors = [
  Colors.blue,
  Colors.green,
  Colors.red,
  Colors.purple,
  Colors.grey,
  Colors.orange,
  Colors.yellow,
];

// Returns true if on desktop and false if on mobile.
isDesktop(context) {
  double screenWidth = MediaQuery.of(context).size.shortestSide;
  bool desktop = screenWidth > 600 ? true : false;

  return desktop;
}

askTime(context, title) async {
  TimeOfDay? pickedTime = await showTimePicker(
    helpText: title,
    initialTime: const TimeOfDay(hour: 00, minute: 00),
    context: context,
    initialEntryMode: TimePickerEntryMode.input,
  );

  return pickedTime;
}

askDate(context, time) async {
  DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: time,
      lastDate: DateTime(DateTime.now().year + 100));

  return pickedDate;
}

formatMeetingTime(meetingTimes) {
  String meetingTimeString = "";

  for (var meetingTime in meetingTimes) {
    int day = meetingTime[0];
    int startHour = meetingTime[1];
    int startMinute = meetingTime[2];
    int endHour = meetingTime[3];
    int endMinute = meetingTime[4];

    if (day == 1) {
      meetingTimeString += "Mon ";
    } else if (day == 2) {
      meetingTimeString += "Tue ";
    } else if (day == 3) {
      meetingTimeString += "Wed ";
    } else if (day == 4) {
      meetingTimeString += "Thu ";
    } else if (day == 5) {
      meetingTimeString += "Fri ";
    } else if (day == 6) {
      meetingTimeString += "Sat ";
    } else if (day == 7) {
      meetingTimeString += "Sun ";
    }

    String formattedStartTime =
        formatTime(DateTime(0, 0, 0, startHour, startMinute));
    String formattedEndTime = formatTime(DateTime(0, 0, 0, endHour, endMinute));

    meetingTimeString += "$formattedStartTime - $formattedEndTime, \n";
  }

  if (meetingTimeString.isNotEmpty) {
    meetingTimeString = meetingTimeString.replaceRange(
        meetingTimeString.length - 3, meetingTimeString.length, "");
  }

  return meetingTimeString;
}

formatTime(time) {
  String formattedTime = "";

  if (time != null) {
    formattedTime = DateFormat.jm().format(time);
  }

  return formattedTime;
}

formatDate(context, date) {
  String formattedDate = "";

  if (date != null) {
    formattedDate = DateFormat.yMd().format(date);
  }

  return formattedDate;
}

catchError(context, awaitFunction) async {
  Navigator.push(context, transitions.fade(const LoadingWheel()));

  try {
    final response = await awaitFunction;
    int statusCode = response.statusCode;

    if (statusCode == 200) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      return statusCode;
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      errorPopup(context, statusCode);
    }
  } catch (_) {
    Navigator.pop(context);
    errorPopup(context, 0);
  }

  return 0;
}
// used for formatting calendar in main calendar
DateTime earliestMeetTime() {
  if (courses.isEmpty) {
    return DateTime.now();
  }
  var earliestDate = courses[0].startDate;
  for (Course course in courses) {
    if (course.startDate < earliestDate) {
      earliestDate = course.startDate;
    }
  }
  return DateTime.fromMillisecondsSinceEpoch(earliestDate);
}

DateTime latestMeetTime() {
  if (courses.isEmpty) {
    return DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch + 1);
  }
  var latestDate = courses[0].endDate;
  for (Course course in courses) {
    if (course.endDate > latestDate) {
      latestDate = course.endDate;
    }
  }
  return DateTime.fromMillisecondsSinceEpoch(latestDate);
}

// recent course/notes lists for homepage
List<Course> recentCourses = [];
List<Note> recentNotes = [];
List<Course> recentNotesOwners = [];

List<int> recentCoursesColorIndices() {
  List<int> colorIndices = [];
  for (var recentCourse in recentCourses) {
    for (int i = 0; i < courses.length; i++) {
      if (courses[i].className == recentCourse.className) {
        colorIndices.add(i);
      }
    }
  }
  return colorIndices;
}

push<T>(var list, var newItem) {
  List<T> newList = [newItem];
  for (T item in list) {
    if (!newList.contains(item)) {
      newList.add(item);
    }
  }
  return newList;
}

// allows repeats in the list, unlike push
pushRepeat<T>(var list, var newItem) {
  List<T> newList = [newItem];
  for (T item in list) {
    newList.add(item);
  }
  return newList;
}

