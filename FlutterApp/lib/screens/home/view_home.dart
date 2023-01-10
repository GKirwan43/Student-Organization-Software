import 'package:Student_Organization_Software/data/functions.dart';
import 'package:Student_Organization_Software/widgets/cards/home_card.dart';
import 'package:Student_Organization_Software/data/backend_access.dart' as data;
import 'package:flutter/material.dart';

class ViewHome extends StatelessWidget {
  const ViewHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          Text(
            "Welcome back, ${data.user.username}!",
            style: Theme.of(context).textTheme.bodyText1,
          ),

          const SizedBox(height: 20),
          const Text("Recently Viewed Courses"),
          const SizedBox(height: 20),

          // Recently Viewed Courses
          Flexible(
            child: FractionallySizedBox(
              heightFactor: 1,
              widthFactor: isDesktop(context) ? .7 : 1,
              child: HomeCard(
                recentList: recentCourses,
              ),
            ),
          ),

          const SizedBox(height: 20),
          const Text("Recently Viewed Notes"),
          const SizedBox(height: 20),

          // Recently Viewed Notes
          Flexible(
            child: FractionallySizedBox(
              heightFactor: 1,
              widthFactor: isDesktop(context) ? .7 : 1,
              child: HomeCard(
                recentList: recentNotes,
              ),
            ),
          ),

          const SizedBox(height: 20),
          const Text("Your Schedule for today"),
          const SizedBox(height: 20),

          // calendar
          Flexible(
            child: Center(
              child: FractionallySizedBox(
                heightFactor: 1,
                widthFactor: isDesktop(context) ? .7 : 1,
                child: const HomeCard(
                  calendar: true,
                ),
              ),
            ),
          ),

          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
