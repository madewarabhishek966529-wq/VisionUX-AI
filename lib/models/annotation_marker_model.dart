import 'package:flutter/material.dart';

class AnnotationMarkerModel {
  final String id;
  final String title;
  final String description;
  final Offset position; // Normalized offset (0.0 - 1.0)
  final String type; // Typography, Contrast, Spacing, Navigation
  final Color color;

  const AnnotationMarkerModel({
    required this.id,
    required this.title,
    required this.description,
    required this.position,
    required this.type,
    this.color = Colors.amber,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'position': [position.dx, position.dy],
      'type': type,
      'color': color.toARGB32(),
    };
  }

  factory AnnotationMarkerModel.fromMap(Map<String, dynamic> map) {
    final posList = (map['position'] as List<dynamic>?)
            ?.map((e) => (e as num).toDouble())
            .toList() ??
        [0.5, 0.5];

    return AnnotationMarkerModel(
      id: map['id'] ?? '',
      title: map['title'] ?? 'UI Issue',
      description: map['description'] ?? '',
      position: Offset(posList[0], posList[1]),
      type: map['type'] ?? 'General',
      color: map['color'] != null ? Color(map['color']) : Colors.amber,
    );
  }
}
