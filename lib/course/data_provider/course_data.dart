import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:restfulapi/course/models/course.dart';
import 'dart:developer' as developer;

class CourseDataProvider {
  // Configure your actual API endpoint here
  static const String baseUrl = 'http://192.168.56.101:5000/api';
  final http.Client httpClient;

  CourseDataProvider({required this.httpClient});

  Future<List<Course>> getCourses() async {
    try {
      developer.log('Attempting to fetch courses from: $baseUrl/courses');

      final response = await httpClient
          .get(
            Uri.parse('$baseUrl/courses'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 15));

      developer.log('Response status code: ${response.statusCode}');
      developer.log(
        'Response body: ${response.body.substring(0, response.body.length > 100 ? 100 : response.body.length)}...',
      );

      if (response.statusCode == 200) {
        final List<dynamic> coursesJson = json.decode(response.body);
        developer.log('Parsed ${coursesJson.length} courses from response');

        return coursesJson
            .map((courseJson) => Course.fromJson(courseJson))
            .toList();
      } else {
        throw HttpException('Failed to load courses: ${response.statusCode}');
      }
    } on FormatException catch (e) {
      developer.log('FormatException: ${e.toString()}');
      throw const FormatException('Invalid response format');
    } on SocketException catch (e) {
      developer.log('SocketException: ${e.toString()}');
      throw SocketException('No internet connection. Details: ${e.message}');
    } on HttpException catch (e) {
      developer.log('HttpException: ${e.toString()}');
      throw HttpException(e.message);
    } on Exception catch (e) {
      developer.log('Exception: ${e.toString()}');
      throw Exception('Something went wrong. Please try again later.');
    }
  }

  Future<Course> getCourseById(String id) async {
    try {
      final response = await httpClient
          .get(
            Uri.parse('$baseUrl/courses/$id'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return Course.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        throw HttpException('Course not found');
      } else {
        throw HttpException('Failed to load course: ${response.statusCode}');
      }
    } on FormatException {
      throw const FormatException('Invalid response format');
    } on SocketException {
      throw const SocketException('No internet connection');
    } on HttpException catch (e) {
      throw HttpException(e.message);
    } on Exception {
      throw Exception('Something went wrong. Please try again later.');
    }
  }

  Future<Course> createCourse(Course course) async {
    try {
      // Remove ID from the course JSON data for creation
      final courseJson = course.toJson();
      courseJson.remove('id'); // MongoDB will create its own _id
      courseJson.remove('_id'); // Also remove _id if present

      developer.log('Creating course with data: ${json.encode(courseJson)}');

      final response = await httpClient
          .post(
            Uri.parse('$baseUrl/courses'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(courseJson),
          )
          .timeout(const Duration(seconds: 15));

      developer.log('Create course response status: ${response.statusCode}');
      developer.log('Create course response body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        return Course.fromJson(json.decode(response.body));
      } else {
        throw HttpException('Failed to create course: ${response.statusCode}');
      }
    } on FormatException catch (e) {
      developer.log('FormatException creating course: ${e.toString()}');
      throw FormatException('Invalid response format');
    } on SocketException catch (e) {
      developer.log('SocketException creating course: ${e.toString()}');
      throw SocketException('No internet connection');
    } on HttpException catch (e) {
      developer.log('HttpException creating course: ${e.toString()}');
      throw HttpException(e.message);
    } on Exception catch (e) {
      developer.log('Exception creating course: ${e.toString()}');
      throw Exception('Something went wrong. Please try again later.');
    }
  }

  Future<Course> updateCourse(Course course) async {
    try {
      final response = await httpClient
          .put(
            Uri.parse('$baseUrl/courses/${course.id}'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(course.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return Course.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        throw HttpException('Course not found');
      } else {
        throw HttpException('Failed to update course: ${response.statusCode}');
      }
    } on FormatException {
      throw const FormatException('Invalid response format');
    } on SocketException {
      throw const SocketException('No internet connection');
    } on HttpException catch (e) {
      throw HttpException(e.message);
    } on Exception {
      throw Exception('Something went wrong. Please try again later.');
    }
  }

  Future<void> deleteCourse(String id) async {
    try {
      final response = await httpClient
          .delete(
            Uri.parse('$baseUrl/courses/$id'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 404) {
        throw HttpException('Course not found');
      } else if (response.statusCode != 200 && response.statusCode != 204) {
        throw HttpException('Failed to delete course: ${response.statusCode}');
      }
    } on SocketException {
      throw const SocketException('No internet connection');
    } on HttpException catch (e) {
      throw HttpException(e.message);
    } on Exception {
      throw Exception('Something went wrong. Please try again later.');
    }
  }
}
