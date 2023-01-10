import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateAssignment extends StatefulWidget {
  const CreateAssignment({super.key});

  @override
  State createState() => _CreateAssignment();
}

class _CreateAssignment extends State<CreateAssignment> {
  TextEditingController nameInput = TextEditingController();
  TextEditingController descriptionInput = TextEditingController();
  TextEditingController dateInput = TextEditingController();
  TextEditingController timeInput = TextEditingController();

  @override
  void initState() {
    super.initState();

    nameInput.text = "";
    descriptionInput.text = "";
    dateInput.text = "";
    timeInput.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create an Assignment'),
      ),
      body: Container(
        margin: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            details(),
            const SizedBox(height: 10),
            due()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        tooltip: 'Create Assignment',
        icon: const Icon(Icons.create),
        label: const Text('Create'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget details() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Details:', style: TextStyle(fontSize: 25)),
        const Divider(
          height: 5,
          thickness: 1,
          endIndent: 0,
          color: Colors.black,
        ),
        const SizedBox(height: 10),
        TextField(
          controller: nameInput,
          decoration: const InputDecoration(
            icon: Icon(Icons.info),
            border: OutlineInputBorder(),
            labelText: 'Name',
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: descriptionInput,
          decoration: const InputDecoration(
            icon: Icon(Icons.description),
            border: OutlineInputBorder(),
            labelText: 'Description',
          ),
        ),
      ],
    );
  }

  Widget due() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Due Date:', style: TextStyle(fontSize: 25)),
          const Divider(
            height: 5,
            thickness: 1,
            endIndent: 0,
            color: Colors.black,
          ),
          const SizedBox(height: 10),
          TextField(
            controller: dateInput,
            decoration: const InputDecoration(
                icon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(),
                labelText: "Date"),
            readOnly: true,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101));

              if (pickedDate != null) {
                String formattedDate =
                    DateFormat('yyyy/MM/dd').format(pickedDate);

                setState(() {
                  dateInput.text = formattedDate;
                });
              }
            },
          ),
          const SizedBox(height: 10),
          TextField(
            controller: timeInput,
            decoration: const InputDecoration(
                icon: Icon(Icons.timer),
                border: OutlineInputBorder(),
                labelText: "Time"),
            readOnly: true,
            onTap: () async {
              TimeOfDay? pickedTime = await showTimePicker(
                initialTime: TimeOfDay.now(),
                context: context,
              );

              if (pickedTime != null) {
                DateTime parsedTime = DateFormat.jm()
                    .parse(pickedTime.format(context).toString());
                String formattedTime =
                    DateFormat('HH:mm:ss').format(parsedTime);

                setState(() {
                  timeInput.text = formattedTime;
                });
              }
            },
          )
        ]);
  }
}
