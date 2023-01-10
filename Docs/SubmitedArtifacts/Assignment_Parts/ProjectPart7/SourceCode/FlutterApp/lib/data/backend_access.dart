import 'package:http/http.dart' as http;
import 'dart:convert';

//Classes to store user data.
class User {
  final String username;
  final String password;
  final List<String> userClasses;
  final String studentType;
  final int studentAge;

  User(
      {required this.username,
      required this.password,
      required this.userClasses,
      required this.studentType,
      required this.studentAge});
}

class Course {
  final List<Note> notes;
  final int startDate;
  final int endDate;
  final List<List<int>> meetingTime;
  final String className;
  final String instructorName;

  Course(
      {required this.notes,
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

// Connection to gradler server.
const server =
    "localhost:8080"; // Localhost for web and 10.0.2.2 used for android simulator.

// Directories
const userSettingsHttp = "userSettings";
const classNotesHttp = "testClass";

String key = "";
dynamic user;
List<Course> courses = [];

// Login into software, checks with backend to see if username and password are valid and returns the reponse.
login(username, password) async {
  try {
    String basicAuth =
        'Basic ${base64.encode(utf8.encode('$username:$password'))}';

    final response = await http.get(
      Uri.http(server, userSettingsHttp),
      headers: <String, String>{'authorization': basicAuth},
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);

      List<String> classes = [];

      for (var currentClass in responseData["UserClasses"]) {
        classes.add(currentClass);
      }

      User newUser = User(
          username: responseData["UserName"],
          password: responseData["Password"],
          userClasses: classes,
          studentType: responseData["StudentType"],
          studentAge: responseData["StudentAge"]);

      key = basicAuth;
      user = newUser;
      courses = await getCourses();
    }

    return response;
  } catch (_) {
    return 0;
  }
}

// Gets courses from backend and populates them in a class.
// This only takes in account if a user only has one course, needs to be fixed to include all courses.
getCourses() async {
  // http request
  final response = await http.get(
    Uri.http(server, classNotesHttp),
    headers: <String, String>{'authorization': key},
  );
  var responseData = json.decode(response.body);

  // create list of classes
  List<Course> courseList = [];

  for (var course in responseData) {
    if (course["id"] == "testUser") {
      // instead of testUser, use user.username
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

      // typecast meetingTimes from List<dynamic> to List<List<int>>
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
          notes: notesList,
          startDate: course["StartDate"],
          endDate: course["EndDate"],
          meetingTime: meetings,
          className: course["ClassName"],
          instructorName: course["InstructorName"]);

      // add course to course list
      courseList.add(newCourse);
    }
  }
  return courseList;
}

// Post does not work yet, backend needs to enabled permissions.
// Do not comment out, needed for widgets within app.

// Creates a class on the backend
// Only posts does not get, this is to reduce http calls so we can stay of free version of azure.
createClass(className, meetingTimes, startDate, endDate, instructorName) async {
  final response = await http.post(Uri.http(server, userSettingsHttp),
      headers: <String, String>{'authorization': key},
      body: jsonEncode(<String, List<String>>{
        'UserClasses': [className]
      }));

  if (response.statusCode == 200) {
    user.userClasses.add(className);
    courses.add(Course(
        notes: [],
        startDate: startDate,
        endDate: endDate,
        meetingTime: meetingTimes,
        className: className,
        instructorName: instructorName));
  }

  return response;
}

// Creates a note on the backend
createNote(course, noteName, noteInfo) async {
  int lastEdited = DateTime.now().millisecondsSinceEpoch;

  final response = await http.post(Uri.http(server, classNotesHttp),
      headers: <String, String>{'authorization': key},
      body: jsonEncode(<String, List<String>>{'Notes': []}));

  if (response.statusCode == 200) {
    course.notes.add(Note(
        lastEdited: lastEdited,
        note: noteInfo,
        noteName: noteName,
        id: course.note.length + 1));
  }

  return response;
}

saveNote(course, note) async {
  int lastEdited = DateTime.now().millisecondsSinceEpoch;

  final response = await http.post(Uri.http(server, classNotesHttp),
      headers: <String, String>{'authorization': key},
      body: jsonEncode(<String, List<String>>{'Notes': []}));

  if (response.statusCode == 200) {
    course.notes[note.id].noteName = note.noteName;
    course.notes[note.id].note = note.note;
    course.notes[note.id].lastEdited = lastEdited;
  }

  return response;
}
