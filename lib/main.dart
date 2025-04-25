import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restfulapi/block_observer.dart';
import 'package:restfulapi/course/bloc/course_bloc.dart';
import 'package:restfulapi/course/bloc/course_event.dart';
import 'package:restfulapi/course/data_provider/course_data.dart';
import 'package:restfulapi/course/repository/course_repository.dart';
import 'package:restfulapi/course/screens/course_route.dart';
import 'package:http/http.dart' as http;

void main() {
  Bloc.observer = SimpleBlocObserver();

  final CourseRepository courseRepository = CourseRepository(
    dataProvider: CourseDataProvider(httpClient: http.Client()),
  );

  runApp(CourseApp(courseRepository: courseRepository));
}

class CourseApp extends StatelessWidget {
  final CourseRepository courseRepository;

  const CourseApp({super.key, required this.courseRepository});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: courseRepository,
      child: BlocProvider(
        create:
            (context) =>
                CourseBloc(courseRepository: courseRepository)
                  ..add(CourseLoad()),
        child: MaterialApp(
          title: 'Course App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.light,
              primary: Colors.blue,
              secondary: Colors.blueAccent,
              tertiary: Colors.lightBlue,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              elevation: 2,
            ),
            cardTheme: CardTheme(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            textTheme: const TextTheme(
              headlineMedium: TextStyle(fontWeight: FontWeight.bold),
              titleLarge: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          onGenerateRoute: CourseAppRoute.generateRoute,
        ),
      ),
    );
  }
}
