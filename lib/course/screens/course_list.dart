import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restfulapi/course/bloc/course_bloc.dart';
import 'package:restfulapi/course/bloc/course_event.dart';
import 'package:restfulapi/course/bloc/course_state.dart';
import 'package:restfulapi/course/models/course.dart';
import 'package:restfulapi/course/screens/course_add_update.dart';
import 'package:restfulapi/course/screens/course_detail.dart';
import 'package:restfulapi/course/screens/course_route.dart';

class CoursesList extends StatelessWidget {
  static const String routeName = '/';

  const CoursesList({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Available Courses',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              BlocProvider.of<CourseBloc>(context).add(const CourseLoad());
            },
          ),
        ],
      ),
      body: BlocBuilder<CourseBloc, CourseState>(
        builder: (context, state) {
          if (state is CourseLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CourseLoadFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60, color: colorScheme.error),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load courses',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: colorScheme.error),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      BlocProvider.of<CourseBloc>(
                        context,
                      ).add(const CourseLoad());
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          if (state is CourseOperationSuccess) {
            final courses = state.courses;

            if (courses.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.school_outlined,
                      size: 80,
                      color: colorScheme.primary.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No courses available',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add your first course by tapping the + button',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final course = courses[index];
                  return _buildCourseCard(context, course);
                },
              ),
            );
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.school_outlined,
                  size: 80,
                  color: colorScheme.primary.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'No courses available',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(
            context,
            AddUpdateCourse.routeName,
            arguments: CourseArgument(edit: false),
          );
        },
        tooltip: 'Add New Course',
        icon: const Icon(Icons.add),
        label: const Text('Add Course'),
      ),
    );
  }

  Widget _buildCourseCard(BuildContext context, Course course) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            CourseDetail.routeName,
            arguments: course,
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course image
            // ClipRRect(
            //   borderRadius: const BorderRadius.vertical(
            //     top: Radius.circular(12),
            //   ),
            //   child: Image.network(
            //     course.imageUrl,
            //     height: 150,
            //     width: double.infinity,
            //     fit: BoxFit.cover,
            //     loadingBuilder: (context, child, loadingProgress) {
            //       if (loadingProgress == null) return child;
            //       return Container(
            //         height: 150,
            //         color: colorScheme.primary.withOpacity(0.1),
            //         child: Center(
            //           child: CircularProgressIndicator(
            //             value:
            //                 loadingProgress.expectedTotalBytes != null
            //                     ? loadingProgress.cumulativeBytesLoaded /
            //                         loadingProgress.expectedTotalBytes!
            //                     : null,
            //             color: colorScheme.primary,
            //           ),
            //         ),
            //       );
            //     },
            //     errorBuilder: (context, error, stackTrace) {
            //       return Container(
            //         height: 150,
            //         color: colorScheme.primary.withOpacity(0.1),
            //         child: Center(
            //           child: Column(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: [
            //               Icon(
            //                 Icons.image_outlined,
            //                 size: 40,
            //                 color: colorScheme.primary.withOpacity(0.5),
            //               ),
            //               const SizedBox(height: 8),
            //               Text(
            //                 'Image not available',
            //                 style: TextStyle(
            //                   color: colorScheme.primary.withOpacity(0.7),
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Course title
                  Text(
                    course.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // Instructor name
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        size: 20, // Fixed size value
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Instructor: ${course.instructor}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Price
                  Row(
                    children: [
                      Icon(
                        Icons.attach_money,
                        size: 20,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '\$${course.price.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Edit button
                      TextButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AddUpdateCourse.routeName,
                            arguments: CourseArgument(
                              course: course,
                              edit: true,
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit'),
                      ),

                      const SizedBox(width: 8),

                      // Delete button
                      TextButton.icon(
                        onPressed: () {
                          _showDeleteConfirmation(context, course);
                        },
                        icon: const Icon(Icons.delete),
                        label: const Text('Delete'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Course course) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
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
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                BlocProvider.of<CourseBloc>(
                  context,
                ).add(CourseDelete(course.id));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
