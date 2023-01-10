import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';
import 'package:Student_Organization_Software/data/backend_access.dart';
import 'package:Student_Organization_Software/data/functions.dart' as functions;

/*
List<Course> testCourses = [
  Course(
    notes: [],
    startDate: DateTime(2022, 8, 22).millisecondsSinceEpoch,
    endDate: DateTime(2022, 12, 15).millisecondsSinceEpoch,
    meetingTime: [
      [1, 13, 0, 13, 50],
      [3, 13, 0, 13, 50],
      [5, 11, 0, 11, 50],
      ],
    className: "Defence Against the Dark Arts",
    instructorName: "Prof. Lockhart",
  ),
  Course(
    notes: [],
    startDate: DateTime(2022, 8, 22).millisecondsSinceEpoch,
    endDate: DateTime(2022, 12, 15).millisecondsSinceEpoch,
    meetingTime: [
      [1, 12, 0, 12, 50],
      [3, 16, 0, 16, 50],
      [5, 12, 0, 12, 50],
      ],
    className: "Divination",
    instructorName: "Prof. Trelawney",
  ),
  Course(
    notes: [],
    startDate: DateTime(2022, 8, 22).millisecondsSinceEpoch,
    endDate: DateTime(2022, 12, 15).millisecondsSinceEpoch,
    meetingTime: [
      [2, 11, 0, 12, 15],
      [3, 11, 0, 12, 15],
      ],
    className: "History of Magic",
    instructorName: "Prof. Binns",
  ),
  Course(
    notes: [],
    startDate: DateTime(2022, 8, 22).millisecondsSinceEpoch,
    endDate: DateTime(2022, 12, 15).millisecondsSinceEpoch,
    meetingTime: [
      [2, 14, 30, 15, 45],
      [3, 14, 30, 15, 45],
      ],
    className: "Potions",
    instructorName: "Prof. Snape",
  ),
];
*/

class MainCalendar extends StatelessWidget {
  const MainCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SfCalendar(
        view: CalendarView.schedule,
        dataSource: ClassMeetingDataSource(getClassMeetingTimes()),
        showDatePickerButton: true,
        minDate: DateTime(2022, 8, 22),
        maxDate: DateTime(2022, 12, 15),
      ),
    );
  }
}

getClassMeetingTimes() {
  List<ClassMeeting> meetings = [];

  int colorIndex = 0;
  // for each course
  courses.forEach((course) {
    // start and end dates
    DateTime startDate = DateTime.fromMillisecondsSinceEpoch(course.startDate);
    DateTime endDate = DateTime.fromMillisecondsSinceEpoch(course.endDate);

    // seperate weekdays and time spans into lists
    List<int> courseWeekDays = [];
    List<ClassMeetSpan> courseMeetSpans = [];
    course.meetingTime.forEach((meet) {
      courseWeekDays.add(meet[0]);
      courseMeetSpans.add(ClassMeetSpan(meet[1], meet[2], meet[3], meet[4]));
    });

    // for every day from startDate to endDate, if the day is a weekday in courses.MeetingTime
    for (DateTime iterateDate = startDate;
        iterateDate.compareTo(endDate) <= 0;
        iterateDate = DateTime(
            iterateDate.year, iterateDate.month, iterateDate.day + 1)) {
      // for every array in MeetingTime array
      for (int i = 0; i < courseWeekDays.length; i++) {
        // if the iterate day is on a MeetingTime day
        if (courseWeekDays[i] == iterateDate.weekday) {
          meetings.add(ClassMeeting(
              course.className,
              DateTime(
                iterateDate.year,
                iterateDate.month,
                iterateDate.day,
                courseMeetSpans[i].startHour,
                courseMeetSpans[i].startMinute,
              ),
              DateTime(
                iterateDate.year,
                iterateDate.month,
                iterateDate.day,
                courseMeetSpans[i].endHour,
                courseMeetSpans[i].endMinute,
              ),
              functions.courseColors[colorIndex]));
        }
      }
    }
    colorIndex = colorIndex >= functions.courseColors.length
        ? 0
        : colorIndex + 1; // cycle through colors
  });

  return meetings;
}

class ClassMeetingDataSource extends CalendarDataSource {
  ClassMeetingDataSource(List<ClassMeeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].className;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }
}

class ClassMeeting {
  ClassMeeting(this.className, this.from, this.to, this.background);

  String className;
  DateTime from;
  DateTime to;
  Color background;
}

class ClassMeetSpan {
  ClassMeetSpan(this.startHour, this.startMinute, this.endHour, this.endMinute);

  int startHour;
  int startMinute;
  int endHour;
  int endMinute;
}
