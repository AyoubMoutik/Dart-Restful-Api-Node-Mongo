import 'package:equatable/equatable.dart';
import 'package:restfulapi/course/models/course.dart';

abstract class CourseEvent extends Equatable {
  const CourseEvent();

  @override
  List<Object?> get props => [];
}

class CourseLoad extends CourseEvent {
  const CourseLoad();
}

class CourseCreate extends CourseEvent {
  final Course course;

  const CourseCreate(this.course);

  @override
  List<Object?> get props => [course];
}

class CourseUpdate extends CourseEvent {
  final Course course;

  const CourseUpdate(this.course);

  @override
  List<Object?> get props => [course];
}

class CourseDelete extends CourseEvent {
  final String id;

  const CourseDelete(this.id);

  @override
  List<Object?> get props => [id];
}
