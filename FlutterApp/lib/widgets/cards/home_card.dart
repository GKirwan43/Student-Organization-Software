import 'package:Student_Organization_Software/data/backend_access.dart';
import 'package:Student_Organization_Software/data/functions.dart';
import 'package:Student_Organization_Software/widgets/text/null_text.dart';
import 'package:flutter/material.dart';
import 'package:Student_Organization_Software/widgets/calendar/main_calendar.dart';
import 'package:Student_Organization_Software/data/transitions.dart'
    as transitions;
import 'package:Student_Organization_Software/screens/notes/view_notes.dart';

class HomeCard extends StatefulWidget {
  const HomeCard({Key? key, this.calendar = false, this.recentList})
      : super(key: key);

  final bool calendar;
  final recentList;

  @override
  State<HomeCard> createState() => _HomeCardState();
}

class _HomeCardState extends State<HomeCard> {
  @override
  Widget build(BuildContext context) {
    if (widget.calendar) {
      // calendar
      return Card(
        elevation: 5,
        child: MainCalendar(
          startDate: DateTime.now(),
          endDate: DateTime.fromMillisecondsSinceEpoch(
              DateTime.now().millisecondsSinceEpoch + 1),
          hideDetails: true,
        ),
      );
    } else {
      // recent courses or notes

      bool isCourses = widget.recentList is List<Course>;
      List<String> name = [];
      List<String> details = [];
      List<int> colorIndices = recentCoursesColorIndices();

      for (int i = 0; i < widget.recentList.length; i++) {
        // get the name field of the item
        name.add(isCourses
            ? widget.recentList[i].className
            : widget.recentList[i].noteName);
        // get the details (ie the meeting time)
        if (isCourses) {
          details.add("");
          for (List<int> meeting in widget.recentList[i].meetingTime) {
            details[i] += meeting == widget.recentList[i].meetingTime[0]
                ? ""
                : ",  "; // formatting
            // choose the right weekday
            details[i] +=
                "${meeting[0] == 1 ? "Mon." : meeting[0] == 2 ? "Tue." : (meeting[0] == 3 ? "Wed." : (meeting[0] == 4 ? "Thu." : (meeting[0] == 5 ? "Fri." : (meeting[0] == 6 ? "Sat." : ("Sun.")))))} @ ${meeting[1] > 12 ? (meeting[1] - 12) : (meeting[1] == 0 ? 12 : meeting[1])} ${meeting[1] >= 12 ? 'pm' : 'am'}";
          }
        } else {
          details.add("");
          details[i] += "from ${recentNotesOwners[i].className}";
        }
      }
      return Card(
        elevation: 5,
        child: widget.recentList.length > 0
            ? SingleChildScrollView(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    for (int i = 0; i < widget.recentList.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2.0),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: isCourses
                                ? courseColors[colorIndices[i]]
                                : Colors.grey,
                            foregroundColor: Colors.grey[200],
                          ),
                          onPressed: () async {
                            if (isCourses) {
                              await Navigator.push(
                                context,
                                isDesktop(context)
                                    ? transitions.fade(
                                        ViewNotes(
                                            course: widget.recentList[i],
                                            updateState: () {}),
                                      )
                                    : transitions.rightToLeft(ViewNotes(
                                        course: widget.recentList[i],
                                        updateState: () {})),
                              );
                              setState(() {});
                            } else {
                              await Navigator.push(
                                context,
                                isDesktop(context)
                                    ? transitions.fade(ViewNotes(
                                        course: recentNotesOwners[i],
                                        updateState: () {}))
                                    : transitions.rightToLeft(ViewNotes(
                                        course: recentNotesOwners[i],
                                        updateState: () {})),
                              );
                              setState(() {});
                            }
                          },
                          child: Row(
                            children: [
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  name[i],
                                ),
                              )),
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  details[i],
                                ),
                              )),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                    NullText(
                        text: "No recent activity",
                        description:
                            "Open a course/note and you can view it here.")
                  ]),
      );
    }
  }
}
