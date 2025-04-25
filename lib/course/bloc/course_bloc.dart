import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restfulapi/course/bloc/course_event.dart';
import 'package:restfulapi/course/bloc/course_state.dart';
import 'package:restfulapi/course/repository/course_repository.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final CourseRepository courseRepository;

  CourseBloc({required this.courseRepository}) : super(CourseInitial()) {
    on<CourseLoad>(_onCourseLoad);
    on<CourseCreate>(_onCourseCreate);
    on<CourseUpdate>(_onCourseUpdate);
    on<CourseDelete>(_onCourseDelete);
  }

  void _onCourseLoad(CourseLoad event, Emitter<CourseState> emit) async {
    emit(CourseLoading());
    try {
      final courses = await courseRepository.getCourses();
      emit(CourseOperationSuccess(courses));
    } catch (error) {
      emit(CourseLoadFailure(error.toString()));
    }
  }

  void _onCourseCreate(CourseCreate event, Emitter<CourseState> emit) async {
    emit(CourseLoading());
    try {
      await courseRepository.createCourse(event.course);
      final courses = await courseRepository.getCourses();
      emit(CourseOperationSuccess(courses));
    } catch (error) {
      emit(CourseOperationFailure(error.toString()));
    }
  }

  void _onCourseUpdate(CourseUpdate event, Emitter<CourseState> emit) async {
    emit(CourseLoading());
    try {
      await courseRepository.updateCourse(event.course);
      final courses = await courseRepository.getCourses();
      emit(CourseOperationSuccess(courses));
    } catch (error) {
      emit(CourseOperationFailure(error.toString()));
    }
  }

  void _onCourseDelete(CourseDelete event, Emitter<CourseState> emit) async {
    emit(CourseLoading());
    try {
      await courseRepository.deleteCourse(event.id);
      final courses = await courseRepository.getCourses();
      emit(CourseOperationSuccess(courses));
    } catch (error) {
      emit(CourseOperationFailure(error.toString()));
    }
  }
}
