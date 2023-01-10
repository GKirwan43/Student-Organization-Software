import 'package:Student_Organization_Software/data/backend_access.dart';
import 'package:Student_Organization_Software/screens/notes/view_notes.dart';
import 'package:Student_Organization_Software/data/transitions.dart'
    as transitions;
import 'package:flutter/material.dart';
import 'package:Student_Organization_Software/data/reusable_strings.dart'
    as strings;
import 'package:Student_Organization_Software/data/functions.dart' as functions;

class ClassCard extends StatelessWidget {
  const ClassCard({Key? key, required this.course, required this.index})
      : super(key: key);

  final Course course;
  final int index;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.shortestSide;
    bool desktop = screenWidth > 600 ? true : false;

    return Container(
        width: desktop ? 350 : double.infinity,
        child: Card(
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 5,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Theme.of(context).colorScheme.outline,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () async {
              await Navigator.push(
                context,
                desktop
                    ? transitions.fade(ViewNotes(course: course))
                    : transitions.rightToLeft(ViewNotes(course: course)),
              );
            },
            child: Column(
              children: <Widget>[
                Container(
                  color: functions.courseColors[index],
                  height: 50,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          child: Container(
                              alignment: Alignment.centerLeft,
                              margin: const EdgeInsets.all(10.0),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  course.className != ""
                                      ? course.className
                                      : strings.noTitle,
                                  style: Theme.of(context).textTheme.headline2,
                                ),
                              ))),
                      PopupMenuButton(
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.white,
                        ),
                        itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                          PopupMenuItem(
                            child: Text(strings.delete),
                            onTap: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 100,
                  width: double.infinity,
                  child: Container(
                    margin: const EdgeInsets.all(10.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Instructor: ${course.instructorName}",
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          Text(
                            "Notes: ${course.notes.length}",
                            style: Theme.of(context).textTheme.bodyText2,
                          )
                        ]),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
