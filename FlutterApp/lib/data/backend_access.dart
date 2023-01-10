import 'package:Student_Organization_Software/data/functions.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uuid/uuid.dart';

//Classes to store user data.
class User {
  final String id;
  final String username;
  final String password;
  final List<String> userClasses;
  final String studentType;
  final int studentAge;

  User(
      {required this.id,
      required this.username,
      required this.password,
      required this.userClasses,
      required this.studentType,
      required this.studentAge});
}

class Course {
  final String id;
  final String noteOwner;
  final List<Note> notes;
  final int startDate;
  final int endDate;
  final List<List<int>> meetingTime;
  final String className;
  final String instructorName;

  Course(
      {required this.id,
      required this.noteOwner,
      required this.notes,
      required this.startDate,
      required this.endDate,
      required this.meetingTime,
      required this.className,
      required this.instructorName});
}

class Note {
  final int id;
  int lastEdited;
  String note;
  String noteName;

  Note(
      {required this.lastEdited,
      required this.note,
      required this.noteName,
      required this.id});
}

class FakeResponse {
  final int statusCode;

  FakeResponse({required this.statusCode});
}

// Connection to gradler server.
const server =
    "52.143.246.146:8080"; // Localhost for web and 10.0.2.2 used for android simulator.

// Directories
const userSettingsHttp = "userSettings";
const classNotesHttp = "classNotes";
const newUserHttp = "NewUser";
const saveNoteHttp = "saveNote";

String key = "";
dynamic user;
List<Course> courses = [];

// Login into software, checks with backend to see if username and password are valid and returns the reponse.
login(username, password) async {
  recentCourses = [];
  recentNotes = [];
  recentNotesOwners = [];

  try {
    String basicAuth =
        'Basic ${base64.encode(utf8.encode('$username:$password'))}';

    final response = await http.get(
      Uri.http(server, userSettingsHttp),
      headers: <String, String>{'authorization': basicAuth},
    );

    if (response.statusCode == 200) {
      key = basicAuth; // Set key
      await populateUser();
      await populateCourses();
    }

    return response.statusCode;
  } catch (_) {
    return 0;
  }
}

// Reset classes to null
logout() {
  key = "";
  user = null;
  courses = [];
}

// Populates user class
populateUser() async {
  final response = await http.get(
    Uri.http(server, userSettingsHttp),
    headers: <String, String>{'authorization': key},
  );
  var responseData = json.decode(response.body);

  List<String> classes = [];

  for (var currentClass in responseData["UserClasses"]) {
    classes.add(currentClass);
  }

  User newUser = User(
      id: responseData["id"],
      username: responseData["UserName"],
      password: responseData["Password"],
      userClasses: classes,
      studentType: responseData["StudentType"],
      studentAge: responseData["StudentAge"]);

  user = newUser;
}

// Populates course class
populateCourses() async {
  var response = await http.get(Uri.http(server, classNotesHttp),
      headers: <String, String>{'authorization': key});
  var responseData = json.decode(response.body);

  // create list of classes
  List<Course> courseList = [];

  for (var course in responseData) {
    // get notes
    List<Note> notesList = [];

    int index = 0;
    for (var noteData in course["Notes"]) {
      Note note = Note(
          lastEdited: noteData["LastEdited"],
          note: noteData["Note"],
          noteName: noteData["NoteName"],
          id: index);

      notesList.add(note);
      index++;
    }

    List<List<int>> meetings = [];
    for (var meeting in course["MeetingTime"]) {
      List<int> newMeeting = [];
      for (var num in meeting) {
        newMeeting.add(num as int);
      }
      meetings.add(newMeeting);
    }

    // put notes in course
    Course newCourse = Course(
        id: course["id"],
        noteOwner: course["NoteOwner"],
        notes: notesList,
        startDate: course["StartDate"],
        endDate: course["EndDate"],
        meetingTime: meetings,
        className: course["ClassName"],
        instructorName: course["InstructorName"]);

    // add course to course list
    courseList.add(newCourse);
  }

  courses = courseList;
}

// Creates a user on the backend.
createUser(username, password) async {
  try {
    var newUser = {};
    newUser["id"] = username;
    newUser["UserName"] = username;
    newUser["Password"] = password;
    newUser["UserClasses"] = [];
    newUser["StudentType"] = "None given";
    newUser["StudentAge"] = -1;

    final response = await http.post(Uri.http(server, newUserHttp),
        body: jsonEncode(newUser));

    if (response.body == "error making user") {
      return 1;
    }

    return 200;
  } catch (_) {
    return 0;
  }
}

// Creates a class on the backend
createClass(className, meetingTimes, startDate, endDate, instructorName) async {
  var uuid = Uuid();

  var newClass = {};
  newClass["id"] = uuid.v1();
  newClass["NoteOwner"] = user.username;
  newClass["Notes"] = [];
  newClass["MeetingTime"] = meetingTimes;
  newClass["StartDate"] = startDate;
  newClass["EndDate"] = endDate;
  newClass["ClassName"] = className;
  newClass["InstructorName"] = instructorName;

  final response = await http.post(Uri.http(server, saveNoteHttp),
      headers: <String, String>{'authorization': key},
      body: jsonEncode(newClass));

  if (response.statusCode == 200) {
    await populateCourses();
  }

  return response;
}

// Creates a note on the backend
createNote(course, noteName, noteInfo) async {
  int lastEdited = DateTime.now().millisecondsSinceEpoch;

  var newClass = {};
  newClass["id"] = course.id;
  newClass["NoteOwner"] = course.noteOwner;
  newClass["Notes"] = [];
  newClass["MeetingTime"] = course.meetingTime;
  newClass["StartDate"] = course.startDate;
  newClass["EndDate"] = course.endDate;
  newClass["ClassName"] = course.className;
  newClass["InstructorName"] = course.instructorName;

  for (var i = 0; i < course.notes.length; i++) {
    if (course.notes[i].noteName == noteName) {
      return FakeResponse(statusCode: 2);
    } else {
      var newNote = {};
      newNote["LastEdited"] = course.notes[i].lastEdited;
      newNote["Note"] = course.notes[i].note;
      newNote["NoteName"] = course.notes[i].noteName;
      newClass["Notes"].add(newNote);
    }
  }

  var newNote = {};
  newNote["LastEdited"] = lastEdited;
  newNote["Note"] = noteInfo;
  newNote["NoteName"] = noteName;
  newClass["Notes"].add(newNote);

  final response = await http.post(Uri.http(server, saveNoteHttp),
      headers: <String, String>{'authorization': key},
      body: jsonEncode(newClass));

  if (response.statusCode == 200) {
    await populateCourses();
  }

  return response;
}

// Saves a note on the backend
saveNote(course, note) async {
  int lastEdited = DateTime.now().millisecondsSinceEpoch;

  var newClass = {};
  newClass["id"] = course.id;
  newClass["NoteOwner"] = course.noteOwner;
  newClass["Notes"] = [];
  newClass["MeetingTime"] = course.meetingTime;
  newClass["StartDate"] = course.startDate;
  newClass["EndDate"] = course.endDate;
  newClass["ClassName"] = course.className;
  newClass["InstructorName"] = course.instructorName;

  for (var i = 0; i < course.notes.length; i++) {
    if (course.notes[i].noteName == note.noteName) {
      var newNote = {};
      newNote["LastEdited"] = lastEdited;
      newNote["Note"] = note.note;
      newNote["NoteName"] = course.notes[i].noteName;
      newClass["Notes"].add(newNote);
    } else {
      var newNote = {};
      newNote["LastEdited"] = course.notes[i].lastEdited;
      newNote["Note"] = course.notes[i].note;
      newNote["NoteName"] = course.notes[i].noteName;
      newClass["Notes"].add(newNote);
    }
  }

  final response = await http.post(Uri.http(server, saveNoteHttp),
      headers: <String, String>{'authorization': key},
      body: jsonEncode(newClass));

  if (response.statusCode == 200) {
    await populateCourses();
  }

  return response;
}
