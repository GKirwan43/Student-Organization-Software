import 'package:Student_Organization_Software/screens/courses/create_course.dart';
import 'package:Student_Organization_Software/data/backend_access.dart' as data;
import 'package:Student_Organization_Software/widgets/text/null_text.dart';
import 'package:flutter/material.dart';
import 'package:Student_Organization_Software/data/transitions.dart'
    as transitions;
import '../../data/backend_access.dart';
import '../../widgets/cards/class_card.dart';
import 'package:Student_Organization_Software/data/reusable_strings.dart'
    as strings;
import 'package:Student_Organization_Software/data/functions.dart' as functions;

// Create state for this widget
class ViewCourses extends StatefulWidget {
  const ViewCourses({Key? key}) : super(key: key);

  @override
  State<ViewCourses> createState() => _ViewCourses();
}

// Widgets state
class _ViewCourses extends State<ViewCourses> {
  @override
  Widget build(BuildContext context) {
    final desktop = functions.isDesktop(context);

    return Scaffold(
      body: _courseList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
              context,
              desktop
                  ? transitions.fade(const CreateCourse())
                  : transitions.up(const CreateCourse()));
          setState(() {});
        },
        tooltip: 'Create Course',
        child: const Icon(Icons.add),
      ),
    );
  }

  // Return what data should be displayed
  Widget _courseList() {
    List<Course> classes = data.courses;
    int classesLength = classes.length;

    final desktop = functions.isDesktop(context);

    if (classesLength != 0) {
      // If classes exist, display them
      return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
              alignment: Alignment.topCenter,
              padding:
                  desktop ? const EdgeInsets.all(50) : const EdgeInsets.all(10),
              child: Wrap(direction: Axis.horizontal, children: [
                for (var i = 0; i < classesLength; i++)
                  Container(
                      padding: const EdgeInsets.all(5),
                      child: ClassCard(
                          course: classes[i],
                          index: i % functions.courseColors.length))
              ])));
    } else {
      // If no classes, say no classes
      return Center(
          child: NullText(
              text: strings.noCourses, description: strings.addCourse));
    }
  }
}
