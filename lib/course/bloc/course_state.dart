import 'package:equatable/equatable.dart';
import 'package:restfulapi/course/models/course.dart';

abstract class CourseState extends Equatable {
  const CourseState();

  @override
  List<Object?> get props => [];
}

class CourseInitial extends CourseState {}

class CourseLoading extends CourseState {}

class CourseOperationSuccess extends CourseState {
  final List<Course> courses;

  const CourseOperationSuccess(this.courses);

  @override
  List<Object> get props => [courses];
}

class CourseLoadFailure extends CourseState {
  final String message;

  const CourseLoadFailure(this.message);

  @override
  List<Object> get props => [message];
}

class CourseOperationFailure extends CourseState {
  final String message;

  const CourseOperationFailure(this.message);

  @override
  List<Object> get props => [message];
}
