import 'package:restfulapi/course/data_provider/course_data.dart';
import 'package:restfulapi/course/models/course.dart';

class CourseRepository {
  final CourseDataProvider dataProvider;

  CourseRepository({required this.dataProvider});

  Future<List<Course>> getCourses() async {
    return dataProvider.getCourses();
  }

  Future<Course> getCourseById(String id) async {
    return dataProvider.getCourseById(id);
  }

  Future<Course> createCourse(Course course) async {
    return dataProvider.createCourse(course);
  }

  Future<Course> updateCourse(Course course) async {
    return dataProvider.updateCourse(course);
  }

  Future<void> deleteCourse(String id) async {
    return dataProvider.deleteCourse(id);
  }
}
