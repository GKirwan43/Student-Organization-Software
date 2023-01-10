import 'package:Student_Organization_Software/data/backend_access.dart';
import 'package:Student_Organization_Software/data/functions.dart' as functions;
import 'package:Student_Organization_Software/data/reusable_strings.dart'
    as strings;
import 'package:flutter/material.dart';

class CreateNote extends StatefulWidget {
  const CreateNote({super.key, required this.course});

  final Course course;

  @override
  State createState() => _CreateNote();
}

class _CreateNote extends State<CreateNote> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameInput = TextEditingController();
  TextEditingController noteInput = TextEditingController();

  @override
  void initState() {
    super.initState();

    nameInput.text = "";
    noteInput.text = "";
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.shortestSide;
    bool desktop = screenWidth > 600 ? true : false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Note'),
      ),
      body: Center(
        child: Container(
          width: desktop ? 750 : null,
          margin: const EdgeInsets.only(
              top: 15.0, left: 15.0, right: 15.0, bottom: 75.0),
          child: courseInfo(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            functions.catchError(context,
                createNote(widget.course, nameInput.text, noteInput.text));
          }
        },
        tooltip: 'Create Note',
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
          children: <Widget>[
            const Text('Note Info:', style: TextStyle(fontSize: 25)),
            const Divider(
              height: 5,
              thickness: 1,
              endIndent: 0,
              color: Colors.black,
            ),
            Card(
                margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                child: Container(
                  margin: const EdgeInsets.all(20.0),
                  width: double.infinity,
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    style: Theme.of(context).textTheme.bodyText1,
                    controller: nameInput,
                    decoration: InputDecoration.collapsed(
                        hintText: strings.noteName,
                        hintStyle: Theme.of(context).textTheme.bodyText1),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return strings.fieldRequired;
                      }
                      return null;
                    },
                  ),
                )),
            Flexible(
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
                  child: Container(
                    margin: const EdgeInsets.all(20.0),
                    width: double.infinity,
                    height: double.infinity,
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      style: Theme.of(context).textTheme.bodyText1,
                      controller: noteInput,
                      decoration: InputDecoration.collapsed(
                          hintText: strings.type,
                          hintStyle: Theme.of(context).textTheme.bodyText1),
                    ),
                  )),
            ),
          ],
        ));
  }
}
