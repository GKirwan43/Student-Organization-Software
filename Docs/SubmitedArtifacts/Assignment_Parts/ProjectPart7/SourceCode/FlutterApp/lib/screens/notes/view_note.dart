import 'package:Student_Organization_Software/data/backend_access.dart';
import 'package:flutter/material.dart';
import 'package:Student_Organization_Software/widgets/popups/confirm.dart'
    as confirm;
import 'package:Student_Organization_Software/data/reusable_strings.dart'
    as strings;
import 'package:Student_Organization_Software/data/functions.dart' as functions;
import 'package:Student_Organization_Software/data/backend_access.dart' as data;
import '../../widgets/cards/note_text_card.dart';

class ViewNote extends StatefulWidget {
  const ViewNote({Key? key, required this.note, required this.course})
      : super(key: key);

  final Note note;
  final Course course;

  @override
  State<ViewNote> createState() => _ViewNote();
}

class _ViewNote extends State<ViewNote> {
  bool noteEdited = false;
  String editedNote = "";

  setNoteEdited(status) {
    setState(() {
      noteEdited = status;
    });
  }

  setEditedNote(text) {
    setState(() {
      editedNote = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note.noteName),
        actions: <Widget>[
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              PopupMenuItem(
                child: const Text('Delete Note'),
                onTap: () {},
              ),
            ],
          ),
        ],
        leading: InkWell(
            child: const Icon(Icons.arrow_back),
            onTap: () async {
              bool eraseEdit = true;

              if (noteEdited) {
                bool save = await confirm.confirmPopup(context);

                if (save) {
                  Note newNote = Note(
                      lastEdited: widget.note.lastEdited,
                      note: editedNote,
                      noteName: widget.note.noteName,
                      id: widget.note.id);

                  // ignore: use_build_context_synchronously
                  var statusCode = functions.catchError(
                      context, data.saveNote(widget.course, newNote));
                  if (statusCode != 200) {
                    eraseEdit = false;
                  }
                }
              }

              if (eraseEdit) {
                setState(() {
                  noteEdited = false;
                  editedNote = "";
                });
                Navigator.pop(context);
              }
            }),
        automaticallyImplyLeading: false,
      ),
      body: Container(
          padding: const EdgeInsets.all(10),
          child: NoteTextCard(
              currentNote: widget.note,
              noteEdited: noteEdited,
              setNoteEdited: setNoteEdited,
              editedNote: editedNote,
              setEditedNote: setEditedNote,
              course: widget.course)),
    );
  }
}
