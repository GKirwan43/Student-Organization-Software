import 'package:Student_Organization_Software/screens/assignments/create_assignment.dart';
import 'package:Student_Organization_Software/widgets/cards/assignment_card.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class ViewAssignments extends StatefulWidget {
  const ViewAssignments({super.key});

  @override
  State createState() => _ViewAssignments();
}

class _ViewAssignments extends State<ViewAssignments> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          builder: (context, snapshot) {
            var data = json.decode(snapshot.data.toString());
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return AssignmentCard(
                    title: data[index]['name'],
                    description: data[index]['description'],
                    dueDate: data[index]['due']['date'],
                    dueTime: (data[index]['due']['time']));
              },
              itemCount: data == null ? 0 : data.length,
            );
          },
          future: DefaultAssetBundle.of(context)
              .loadString("data/assignments.json")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateAssignment()),
          );
        },
        tooltip: 'Create Assignment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
