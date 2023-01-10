import 'package:Student_Organization_Software/data/backend_access.dart';
import 'package:Student_Organization_Software/screens/notes/create_note.dart';
import 'package:Student_Organization_Software/widgets/cards/note_card.dart';
import 'package:Student_Organization_Software/data/transitions.dart'
    as transitions;
import 'package:Student_Organization_Software/data/reusable_strings.dart'
    as strings;
import 'package:Student_Organization_Software/data/functions.dart' as functions;
import 'package:Student_Organization_Software/widgets/popups/confirm.dart'
    as confirm;
import 'package:Student_Organization_Software/data/backend_access.dart' as data;
import 'package:Student_Organization_Software/widgets/cards/note_text_card.dart';
import 'package:Student_Organization_Software/widgets/text/null_text.dart';
import 'package:flutter/material.dart';

import '../../widgets/text/title_text.dart';

// Create state for this widget
class ViewNotes extends StatefulWidget {
  const ViewNotes({super.key, required this.course});

  final Course course;

  @override
  State<ViewNotes> createState() => _ViewNotes();
}

// Widgets state
class _ViewNotes extends State<ViewNotes> {
  dynamic currentNote;
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
    final desktop = functions.isDesktop(context);
    List<Note> classNotes = widget.course.notes;
    int classNotesLength = classNotes.length;
    String className = widget.course.className;
    bool valid = classNotesLength > 0 ? true : false;

    return Scaffold(
      appBar: AppBar(
        title: Text(className != "" ? className : strings.noTitle),
        leading: InkWell(
            child: const Icon(Icons.arrow_back),
            onTap: () async {
              bool eraseEdit = true;

              if (noteEdited) {
                bool save = await confirm.confirmPopup(context);

                if (save) {
                  Note newNote = Note(
                      lastEdited: currentNote.lastEdited,
                      note: editedNote,
                      noteName: currentNote.noteName,
                      id: currentNote.id);

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
      body: valid
          ? desktop
              ? Container(
                  padding: const EdgeInsets.all(50),
                  child: Row(children: <Widget>[
                    Expanded(
                        flex: 1,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              TitleText(text: strings.allNotes),
                              Flexible(
                                  child: Container(
                                      padding: const EdgeInsets.all(5),
                                      child: _noteList(
                                          classNotes, classNotesLength)))
                            ])),
                    Expanded(
                        flex: 2,
                        child: currentNote != null
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                    TitleText(text: currentNote.noteName),
                                    Flexible(
                                        child: Container(
                                            padding: const EdgeInsets.all(5),
                                            child: NoteTextCard(
                                                currentNote: currentNote,
                                                noteEdited: noteEdited,
                                                setNoteEdited: setNoteEdited,
                                                editedNote: editedNote,
                                                setEditedNote: setEditedNote,
                                                course: widget.course)))
                                  ])
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                    TitleText(
                                        text: strings.noNoteSelectedSmall),
                                    Flexible(
                                        child: Container(
                                            padding: const EdgeInsets.all(5),
                                            child: Card(
                                                margin: EdgeInsets.zero,
                                                clipBehavior:
                                                    Clip.antiAliasWithSaveLayer,
                                                elevation: 5,
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .outline,
                                                  ),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(12)),
                                                ),
                                                child: Container(
                                                    margin:
                                                        const EdgeInsets.all(
                                                            20.0),
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                    child: NullText(
                                                        text: strings
                                                            .noNoteSelected,
                                                        description: strings
                                                            .selectNote)))))
                                  ]))
                  ]))
              : Container(
                  padding: const EdgeInsets.all(10),
                  child: _noteList(classNotes, classNotesLength))
          : NullText(text: strings.noNotes, description: strings.addNote),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
              context,
              desktop
                  ? transitions.fade(CreateNote(course: widget.course))
                  : transitions.up(CreateNote(course: widget.course)));
          setState(() {});
        },
        tooltip: 'New Note',
        child: const Icon(Icons.add),
      ),
    );
  }

  // Return what data should be displayed
  Widget _noteList(classNotes, classNotesLength) {
    setCurrentNote(note) async {
      bool switchNote = true;

      if (noteEdited) {
        bool save = await confirm.confirmPopup(context);

        if (save) {
          Note newNote = Note(
              lastEdited: currentNote.lastEdited,
              note: editedNote,
              noteName: currentNote.noteName,
              id: currentNote.id);

          // ignore: use_build_context_synchronously
          var statusCode = functions.catchError(
              context, data.saveNote(widget.course, newNote));
          if (statusCode != 200) {
            switchNote = false;
          }
        }
      }

      if (switchNote) {
        setState(() {
          currentNote = note;
          noteEdited = false;
          editedNote = "";
        });
      }
    }

    return ListView.builder(
        itemCount: classNotesLength,
        itemBuilder: (ctx, index) => Container(
              padding: EdgeInsets.only(bottom: 5),
              child: NoteCard(
                  note: classNotes[index],
                  currentNote: currentNote,
                  setCurrentNote: setCurrentNote,
                  course: widget.course),
            ));
  }
}
