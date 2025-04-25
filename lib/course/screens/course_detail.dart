import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restfulapi/course/bloc/course_bloc.dart';
import 'package:restfulapi/course/bloc/course_event.dart';
import 'package:restfulapi/course/models/course.dart';
import 'package:restfulapi/course/screens/course_add_update.dart';
import 'package:restfulapi/course/screens/course_route.dart';

class CourseDetail extends StatelessWidget {
  static const String routeName = '/course_detail';

  final Course course;

  const CourseDetail({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Custom app bar with course image as background
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                course.title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 3,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Course image
                  Image.network(
                    course.imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: colorScheme.primaryContainer,
                        child: Center(
                          child: CircularProgressIndicator(
                            value:
                                loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      // Get initials from course title
                      final List<String> words = course.title.split(' ');
                      String initials = '';

                      // Take first letter of first two words
                      for (int i = 0; i < words.length && i < 2; i++) {
                        if (words[i].isNotEmpty) {
                          initials += words[i][0].toUpperCase();
                        }
                      }

                      // If we couldn't get at least one initial, use a default
                      if (initials.isEmpty) {
                        initials = 'C';
                      }

                      // Generate a predictable color based on the course title
                      final int colorValue = course.title.hashCode;
                      final Color avatarColor = Color(
                        colorValue,
                      ).withOpacity(1.0);

                      return Container(
                        color: colorScheme.surface,
                        child: Center(
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: avatarColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                initials,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  // Gradient overlay for better text visibility
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    AddUpdateCourse.routeName,
                    arguments: CourseArgument(course: course, edit: true),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.white),
                onPressed: () {
                  _showDeleteConfirmation(context);
                },
              ),
            ],
          ),

          // Course content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price and instructor card
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          // Price section
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Price',
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: colorScheme.primary,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '\$${course.price.toStringAsFixed(2)}',
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: colorScheme.primary,
                                      ),
                                ),
                              ],
                            ),
                          ),

                          // Vertical divider
                          Container(
                            height: 60,
                            width: 1,
                            color: Colors.grey.withOpacity(0.3),
                          ),

                          // Instructor section
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Instructor',
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: colorScheme.primary,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  course.instructor,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 24),

                  // Description section
                  Text(
                    'Description',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colorScheme.outlineVariant,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      course.description,
                      style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
                    ),
                  ),

                  SizedBox(height: 40),

                  // Enroll button
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Show a snackbar for enroll action
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Enrolled in ${course.title}'),
                            backgroundColor: colorScheme.primary,
                          ),
                        );
                      },
                      icon: Icon(Icons.school),
                      label: Text('Enroll Now'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primaryContainer,
                        foregroundColor: colorScheme.onPrimaryContainer,
                        padding: EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete "${course.title}"?'),
          actions: [
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: colorScheme.primary),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                BlocProvider.of<CourseBloc>(
                  context,
                ).add(CourseDelete(course.id));
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
