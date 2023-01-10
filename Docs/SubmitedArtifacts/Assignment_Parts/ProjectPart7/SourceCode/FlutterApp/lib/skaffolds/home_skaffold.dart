import 'package:Student_Organization_Software/screens/courses/view_courses.dart';
import 'package:Student_Organization_Software/screens/home/view_home.dart';
import 'package:Student_Organization_Software/widgets/calendar/main_calendar.dart';
import 'package:flutter/material.dart';
import 'package:Student_Organization_Software/data/reusable_strings.dart'
    as strings;
import 'package:Student_Organization_Software/data/functions.dart' as functions;

class HomeSkaffold extends StatefulWidget {
  const HomeSkaffold({super.key});

  @override
  State createState() => _HomeSkaffold();
}

class _HomeSkaffold extends State<HomeSkaffold> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final desktop = functions.isDesktop(context);

    if (!desktop && _scaffoldKey.currentState?.isDrawerOpen == true) {
      _scaffoldKey.currentState?.closeDrawer();
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(strings.getScaffoldTitle(currentPageIndex)),
        actions: desktop
            ? null
            : <Widget>[
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                    PopupMenuItem(
                      child: Text(strings.logout),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                )
              ],
        automaticallyImplyLeading: desktop,
      ),
      body: Container(
        alignment: Alignment.center,
        child: [
          const ViewHome(),
          const ViewCourses(),
          const MainCalendar(),
        ][currentPageIndex],
      ),
      drawer: desktop ? navDrawer() : null,
      bottomNavigationBar: desktop ? null : navBar(),
    );
  }

  Widget navDrawer() {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(10.0),
            width: double.infinity,
            height: 100,
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(strings.title,
                style: Theme.of(context).textTheme.headline2),
          ),
          ListTile(
            title: Text(strings.home),
            leading: const Icon(Icons.home),
            onTap: () {
              setState(() {
                currentPageIndex = 0;
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(strings.courses),
            leading: const Icon(Icons.bookmark_border),
            onTap: () {
              setState(() {
                currentPageIndex = 1;
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(strings.calendar),
            leading: const Icon(Icons.calendar_today),
            onTap: () {
              setState(() {
                currentPageIndex = 2;
              });
              Navigator.pop(context);
            },
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: ListTile(
                    title: Text(strings.logout),
                    leading: const Icon(Icons.arrow_back_sharp),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget navBar() {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          label: strings.home,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.bookmark_border),
          label: strings.courses,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.calendar_today),
          label: strings.calendar,
        ),
      ],
      currentIndex: currentPageIndex,
      selectedItemColor: Theme.of(context).primaryColor,
      onTap: (int index) {
        setState(() {
          currentPageIndex = index;
        });
      },
    );
  }
}
