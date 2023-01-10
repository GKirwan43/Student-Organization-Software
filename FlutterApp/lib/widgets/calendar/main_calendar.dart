import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';
import 'package:Student_Organization_Software/data/backend_access.dart';
import 'package:Student_Organization_Software/data/functions.dart' as functions;

class MainCalendar extends StatelessWidget {
  const MainCalendar({Key? key, required this.startDate, required this.endDate, 
  this.hideDetails=false}) : super(key: key);

  final DateTime startDate;
  final DateTime endDate;
  final bool hideDetails;

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      headerHeight: !hideDetails ? 40 : 0,
      view: CalendarView.schedule,
      dataSource: ClassMeetingDataSource(getClassMeetingTimes(functions.earliestMeetTime(), functions.latestMeetTime())),
      showDatePickerButton: !hideDetails,
      minDate: startDate,
      maxDate: endDate,
      scheduleViewSettings: ScheduleViewSettings(
        monthHeaderSettings: MonthHeaderSettings(
          height: !hideDetails ? 150 : 0,
        ),
        weekHeaderSettings: WeekHeaderSettings(
          height: !hideDetails ? 30 : 0,
        ),
        dayHeaderSettings: DayHeaderSettings(
          width: !hideDetails ? -1 : 0,
        ),
      ),
    );
  }
}

getClassMeetingTimes(DateTime startDate, DateTime endDate) {
  List<ClassMeeting> meetings = [];

  int colorIndex = 0;
  // for each course
  for (var course in courses) {

    // seperate weekdays and time spans into lists
    List<int> courseWeekDays = [];
    List<ClassMeetSpan> courseMeetSpans = [];
    for (var meet in course.meetingTime) {
      courseWeekDays.add(meet[0]);
      courseMeetSpans.add(ClassMeetSpan(meet[1], meet[2], meet[3], meet[4]));
    }

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
  }

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
