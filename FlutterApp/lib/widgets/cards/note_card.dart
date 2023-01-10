import 'package:Student_Organization_Software/data/backend_access.dart';
import 'package:Student_Organization_Software/screens/notes/view_note.dart';
import 'package:Student_Organization_Software/data/transitions.dart'
    as transitions;
import 'package:flutter/material.dart';
import 'package:Student_Organization_Software/data/functions.dart' as functions;

class NoteCard extends StatefulWidget {
  const NoteCard(
      {Key? key,
      required this.note,
      required this.currentNote,
      required this.setCurrentNote,
      required this.updateNoteMobile,
      required this.course})
      : super(key: key);

  final Note note;
  final dynamic currentNote;
  final Function setCurrentNote;
  final Function updateNoteMobile;
  final Course course;

  @override
  State createState() => _NoteCard();
}

class _NoteCard extends State<NoteCard> {
  @override
  Widget build(BuildContext context) {
    final desktop = functions.isDesktop(context);
    bool selected = widget.note.noteName ==
                (widget.currentNote != null
                    ? widget.currentNote.noteName
                    : "") &&
            desktop
        ? true
        : false;

    return Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 5,
        color: selected ? Theme.of(context).colorScheme.primary : Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(20.0),
                child: Text(
                  widget.note.noteName,
                  overflow: TextOverflow.ellipsis,
                  style: selected
                      ? Theme.of(context).textTheme.headline1
                      : Theme.of(context).textTheme.bodyText1,
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20.0),
                child: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black,
                  size: 30.0,
                ),
              ),
            ],
          ),
          onTap: () {
            functions.recentNotes = functions.push<Note>(functions.recentNotes, widget.note);
            functions.recentNotesOwners = functions.pushRepeat<Course>(functions.recentNotesOwners, widget.course);
            if (desktop) {
              widget.setCurrentNote(widget.note);
            } else {
              Navigator.push(
                  context,
                  transitions.rightToLeft(ViewNote(
                      note: widget.note,
                      course: widget.course,
                      updateNoteMobile: widget.updateNoteMobile,
                      desktop: desktop)));
            }
          },
        ));
  }
}
