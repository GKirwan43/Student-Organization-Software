import 'package:Student_Organization_Software/data/backend_access.dart';
import 'package:Student_Organization_Software/data/reusable_strings.dart'
    as strings;
import 'package:Student_Organization_Software/data/backend_access.dart' as data;
import 'package:Student_Organization_Software/data/functions.dart' as functions;
import 'package:flutter/material.dart';

class NoteTextCard extends StatefulWidget {
  const NoteTextCard(
      {Key? key,
      required this.currentNote,
      required this.noteEdited,
      required this.setNoteEdited,
      required this.editedNote,
      required this.setEditedNote,
      required this.course})
      : super(key: key);

  final Note currentNote;
  final bool noteEdited;
  final Function setNoteEdited;
  final String editedNote;
  final Function setEditedNote;
  final Course course;

  @override
  State<NoteTextCard> createState() => _NoteTextCard();
}

class _NoteTextCard extends State<NoteTextCard> {
  TextEditingController noteInput = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (!widget.noteEdited) {
      noteInput.text = widget.currentNote.note;
    }

    return Scaffold(
      body: Card(
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
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            style: Theme.of(context).textTheme.bodyText1,
            controller: noteInput,
            decoration: InputDecoration.collapsed(
                hintText: strings.type,
                hintStyle: Theme.of(context).textTheme.bodyText1),
            onChanged: (_) {
              widget.setNoteEdited(true);
              widget.setEditedNote(noteInput.text);
            },
          ),
        ),
      ),
      floatingActionButton: widget.noteEdited
          ? FloatingActionButton.extended(
              heroTag: "save",
              onPressed: () {
                Note newNote = Note(
                    lastEdited: widget.currentNote.lastEdited,
                    note: widget.editedNote,
                    noteName: widget.currentNote.noteName,
                    id: widget.currentNote.id);

                // ignore: use_build_context_synchronously
                functions.catchError(
                    context, data.saveNote(widget.course, newNote));
              },
              tooltip: strings.saveNote,
              icon: const Icon(Icons.create),
              label: Text(strings.save),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
