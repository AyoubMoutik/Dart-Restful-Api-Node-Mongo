import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restfulapi/course/bloc/course_bloc.dart';
import 'package:restfulapi/course/bloc/course_event.dart';
import 'package:restfulapi/course/bloc/course_state.dart';
import 'package:restfulapi/course/models/course.dart';
import 'package:restfulapi/course/screens/course_route.dart';
import 'package:uuid/uuid.dart';

class AddUpdateCourse extends StatefulWidget {
  static const String routeName = '/add_update_course';

  final CourseArgument args;

  const AddUpdateCourse({super.key, required this.args});

  @override
  State<AddUpdateCourse> createState() => _AddUpdateCourseState();
}

class _AddUpdateCourseState extends State<AddUpdateCourse> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _instructorController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController();
  bool _isPreviewVisible = false;

  bool get isEditing => widget.args.edit;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _titleController.text = widget.args.course!.title;
      _instructorController.text = widget.args.course!.instructor;
      _descriptionController.text = widget.args.course!.description;
      _priceController.text = widget.args.course!.price.toString();
      _imageUrlController.text = widget.args.course!.imageUrl;
      _isPreviewVisible = true;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _instructorController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  // Custom widget to create a styled input field
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    VoidCallback? onEditingComplete,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        style: TextStyle(
          fontSize: 16,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: validator,
        onEditingComplete: onEditingComplete,
      ),
    );
  }

  // Custom image preview widget
  Widget _buildImagePreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0, left: 4.0),
          child: Text(
            'Image Preview',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
              width: 1,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child:
              _imageUrlController.text.isNotEmpty
                  ? Image.network(
                    _imageUrlController.text,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Get initials from course title
                      final List<String> words = _titleController.text.split(
                        ' ',
                      );
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
                      final int colorValue = _titleController.text.hashCode;
                      final Color avatarColor = Color(
                        colorValue,
                      ).withOpacity(1.0);

                      return Container(
                        color: Theme.of(context).colorScheme.surface,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: avatarColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    initials,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Invalid image URL',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                  : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_outlined,
                          size: 48,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Enter a valid image URL to see preview',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Course' : 'Add Course'),
        elevation: 0,
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
      ),
      body: BlocListener<CourseBloc, CourseState>(
        listener: (context, state) {
          if (state is CourseOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  isEditing
                      ? 'Course updated successfully!'
                      : 'Course added successfully!',
                ),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop();
          }

          if (state is CourseOperationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Operation failed: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Container(
          color: colorScheme.primaryContainer.withOpacity(0.1),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Course title
                          _buildInputField(
                            controller: _titleController,
                            label: 'Course Title',
                            icon: Icons.title,
                            hint: 'Enter the course title',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a title';
                              }
                              return null;
                            },
                          ),

                          // Instructor
                          _buildInputField(
                            controller: _instructorController,
                            label: 'Instructor',
                            icon: Icons.person,
                            hint: 'Enter instructor name',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an instructor name';
                              }
                              return null;
                            },
                          ),

                          // Price
                          _buildInputField(
                            controller: _priceController,
                            label: 'Price (\$)',
                            icon: Icons.attach_money,
                            hint: 'Enter course price',
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a price';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Please enter a valid number';
                              }
                              return null;
                            },
                          ),

                          // Image URL with preview button
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _buildInputField(
                                  controller: _imageUrlController,
                                  label: 'Image URL',
                                  icon: Icons.image,
                                  hint: 'https://example.com/image.png',
                                  onEditingComplete: () {
                                    if (_imageUrlController.text.isNotEmpty) {
                                      setState(() {
                                        _isPreviewVisible = true;
                                      });
                                    }
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter an image URL';
                                    }

                                    // Validate URL format
                                    try {
                                      final uri = Uri.parse(value);
                                      if (!uri.isAbsolute ||
                                          ![
                                            'http',
                                            'https',
                                          ].contains(uri.scheme)) {
                                        return 'Please enter a valid http/https URL';
                                      }
                                    } catch (e) {
                                      return 'Please enter a valid URL';
                                    }

                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      _isPreviewVisible = !_isPreviewVisible;
                                    });
                                  },
                                  icon: Icon(
                                    _isPreviewVisible
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  label: Text(
                                    _isPreviewVisible ? 'Hide' : 'Preview',
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        colorScheme.primaryContainer,
                                    foregroundColor:
                                        colorScheme.onPrimaryContainer,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                      horizontal: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Image preview section
                          if (_isPreviewVisible)
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 8.0,
                                bottom: 16.0,
                              ),
                              child: _buildImagePreview(),
                            ),

                          // Description
                          _buildInputField(
                            controller: _descriptionController,
                            label: 'Description',
                            icon: Icons.description,
                            hint: 'Enter course description',
                            maxLines: 5,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a description';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final course = Course(
                            id:
                                isEditing
                                    ? widget.args.course!.id
                                    : const Uuid().v4(),
                            title: _titleController.text,
                            description: _descriptionController.text,
                            imageUrl: _imageUrlController.text,
                            instructor: _instructorController.text,
                            price: double.parse(_priceController.text),
                          );

                          if (isEditing) {
                            context.read<CourseBloc>().add(
                              CourseUpdate(course),
                            );
                          } else {
                            context.read<CourseBloc>().add(
                              CourseCreate(course),
                            );
                          }
                        }
                      },
                      icon: Icon(isEditing ? Icons.update : Icons.add),
                      label: Text(
                        isEditing ? 'Update Course' : 'Add Course',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
