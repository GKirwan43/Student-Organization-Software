import 'package:Student_Organization_Software/data/backend_access.dart';
import 'package:flutter/material.dart';
import 'package:Student_Organization_Software/data/functions.dart' as functions;
import 'package:Student_Organization_Software/data/reusable_strings.dart'
    as strings;
import 'package:Student_Organization_Software/widgets/popups/pick_days.dart'
    as pick_days;

class CreateCourse extends StatefulWidget {
  const CreateCourse({super.key});

  @override
  State createState() => _CreateCourse();
}

class _CreateCourse extends State<CreateCourse> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameInput = TextEditingController();
  TextEditingController instructorsNameInput = TextEditingController();
  TextEditingController meetingDay = TextEditingController();
  TextEditingController startDate = TextEditingController();
  TextEditingController endDate = TextEditingController();

  @override
  void initState() {
    super.initState();

    nameInput.text = "";
    instructorsNameInput.text = "";
    meetingDay.text = "";
    startDate.text = "";
    endDate.text = "";
  }

  int? startDateMili = 0;
  int? endDateMili = 0;
  List<List<int>> meetingTimesArray = [];

  @override
  Widget build(BuildContext context) {
    final desktop = functions.isDesktop(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a Course'),
      ),
      body: Center(
          child: Container(
        width: desktop ? 500 : null,
        margin: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            courseInfo(),
          ],
        ),
      )),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            var statusCode = await functions.catchError(
                context,
                createClass(nameInput.text, meetingTimesArray, startDateMili,
                    endDateMili, instructorsNameInput.text));

            if (statusCode == 200) {
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            }
          }
        },
        tooltip: 'Create Course',
        icon: const Icon(Icons.create),
        label: const Text('Create'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget courseInfo() {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Course Info:', style: TextStyle(fontSize: 25)),
            const Divider(
              height: 5,
              thickness: 1,
              endIndent: 0,
              color: Colors.black,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: nameInput,
              decoration: const InputDecoration(
                icon: Icon(Icons.info),
                border: OutlineInputBorder(),
                labelText: 'Name',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return strings.fieldRequired;
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: instructorsNameInput,
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                border: OutlineInputBorder(),
                labelText: 'Instructors Name',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return strings.fieldRequired;
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: meetingDay,
              decoration: const InputDecoration(
                icon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(),
                labelText: 'Meeting Days',
              ),
              readOnly: true,
              onTap: () async {
                List<List<int>> meetingTimes =
                    await pick_days.pickDays(context);

                String formatedMeetingTime =
                    functions.formatMeetingTime(meetingTimes);

                if (formatedMeetingTime.isNotEmpty) {
                  setState(() {
                    meetingDay.text = formatedMeetingTime;
                    meetingTimesArray = meetingTimes;
                  });
                } else {
                  setState(() {
                    meetingDay.clear();
                  });
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return strings.fieldRequired;
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: startDate,
              decoration: const InputDecoration(
                icon: Icon(Icons.watch_later_outlined),
                border: OutlineInputBorder(),
                labelText: 'Start Date',
              ),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await functions.askDate(
                    context, DateTime(DateTime.now().year));
                // ignore: use_build_context_synchronously
                String formattedDate =
                    await functions.formatDate(context, pickedDate);

                setState(() {
                  startDate.text = formattedDate;
                  startDateMili = pickedDate?.millisecondsSinceEpoch;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return strings.fieldRequired;
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            if (startDate.text.isNotEmpty)
              TextFormField(
                controller: endDate,
                decoration: const InputDecoration(
                  icon: Icon(Icons.watch_later_outlined),
                  border: OutlineInputBorder(),
                  labelText: 'End Date',
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await functions.askDate(context,
                      DateTime.fromMillisecondsSinceEpoch(startDateMili!));
                  // ignore: use_build_context_synchronously
                  String formattedDate =
                      await functions.formatDate(context, pickedDate);

                  setState(() {
                    endDate.text = formattedDate;
                    endDateMili = pickedDate?.millisecondsSinceEpoch;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return strings.fieldRequired;
                  }
                  return null;
                },
              )
          ],
        ));
  }
}
