import 'package:flutter/material.dart';
import 'package:restfulapi/course/models/course.dart';
import 'package:restfulapi/course/screens/course_list.dart';
import 'package:restfulapi/course/screens/course_add_update.dart';
import 'package:restfulapi/course/screens/course_detail.dart';

class CourseAppRoute {
  static Route generateRoute(RouteSettings settings) {
    if (settings.name == '/') {
      return MaterialPageRoute(builder: (context) => CoursesList());
    }

    if (settings.name == AddUpdateCourse.routeName) {
      CourseArgument args = settings.arguments as CourseArgument;
      return MaterialPageRoute(
        builder: (context) => AddUpdateCourse(args: args),
      );
    }

    if (settings.name == CourseDetail.routeName) {
      Course course = settings.arguments as Course;
      return MaterialPageRoute(
        builder: (context) => CourseDetail(course: course),
      );
    }

    return MaterialPageRoute(builder: (context) => CoursesList());
  }
}

class CourseArgument {
  final Course? course;
  final bool edit;

  CourseArgument({this.course, required this.edit});
}
