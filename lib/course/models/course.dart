import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Course extends Equatable {
  const Course({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.instructor,
    required this.price,
  });

  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String instructor;
  final double price;

  @override
  List<Object> get props => [
    id,
    title,
    description,
    imageUrl,
    instructor,
    price,
  ];

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['_id'] ?? json['id'], // Handle both _id (MongoDB) and id fields
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      instructor: json['instructor'],
      price: (json['price'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      '_id': id, // Include both id and _id for compatibility with MongoDB
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'instructor': instructor,
      'price': price,
    };
  }

  Course copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    String? instructor,
    double? price,
  }) {
    return Course(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      instructor: instructor ?? this.instructor,
      price: price ?? this.price,
    );
  }

  @override
  String toString() =>
      'Course { id: $id, title: $title, description: $description, imageUrl: $imageUrl, instructor: $instructor, price: $price }';
}
