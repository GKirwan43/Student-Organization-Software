// Reusable strings that are used multiple times within the app.

String title = "Student Organization Software";
String logout = "Logout";
String create = "Create";
String home = "Home";
String courses = "Courses";
String yourCourses = "Your Courses";
String delete = "Delete";
String calendar = "Calendar";
String noCourses = "You have not created any courses";
String addCourse = "Click the '+' to create a course";
String noNotes = "You have not created any notes for this course";
String addNote = "Click the '+' to create a note";
String notes = "Notes";
String allNotes = "All notes for this class";
String noNoteSelected = "You have not selected a note";
String selectNote = "Select a note on the left to view";
String noTitle = "No Title";
String fieldRequired = "This field is required";
String cancel = "Cancel";
String submit = "Submit";
String type = "This note it empty. Type here edit";
String unsavedNote = "Unsaved Note";
String saveNoteQuestion = "Do you want to save this note?";
String saveNote = "Save note";
String save = "Save";
String noteName = "Note name";
String noNoteSelectedSmall = "No note selected";
String invalidTime = "Invalid time range";
String timeError = "Class cannot end before it has started";

// Return string based on index.
getScaffoldTitle(index) {
  switch (index) {
    case 0:
      return home;
    case 1:
      return yourCourses;
    case 2:
      return calendar;
  }
}

// Return string based on error code.
getError(code) {
  switch (code) {
    case 0:
      return "Could not connect to server";
    case 1:
      return "Could not create user";
    case 2:
      return "Note with that name already exists";
    case 200:
      return "Success";
    case 201:
      return "Created";
    case 202:
      return "Accepted";
    case 400:
      return "Could not connect to server";
    case 401:
      return "Incorrect username or password";
    case 403:
      return "Unauthorized access";
    case 404:
      return "Not found";
    case 405:
      return "Method Not Allowed";
    default:
      return "An unknown error occured";
  }
}
