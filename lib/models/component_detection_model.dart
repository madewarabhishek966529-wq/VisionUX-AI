import 'package:flutter/material.dart';
import '../config/app_constants.dart';

class ComponentDetectionModel {
  final String id;
  final ComponentType type;
  final String label;
  final Rect boundingBox; // Normalized [left, top, width, height] (0.0 to 1.0)
  final double confidence; // 0.0 to 1.0
  final Map<String, dynamic> attributes; // e.g. padding, contrast, font_size

  const ComponentDetectionModel({
    required this.id,
    required this.type,
    required this.label,
    required this.boundingBox,
    required this.confidence,
    this.attributes = const {},
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.name,
      'label': label,
      'boundingBox': [
        boundingBox.left,
        boundingBox.top,
        boundingBox.width,
        boundingBox.height
      ],
      'confidence': confidence,
      'attributes': attributes,
    };
  }

  factory ComponentDetectionModel.fromMap(Map<String, dynamic> map) {
    final boxList = (map['boundingBox'] as List<dynamic>?)
            ?.map((e) => (e as num).toDouble())
            .toList() ??
        [0.0, 0.0, 1.0, 1.0];

    return ComponentDetectionModel(
      id: map['id'] ?? '',
      type: ComponentType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => ComponentType.button,
      ),
      label: map['label'] ?? 'Component',
      boundingBox: Rect.fromLTWH(boxList[0], boxList[1], boxList[2], boxList[3]),
      confidence: (map['confidence'] ?? 0.95).toDouble(),
      attributes: Map<String, dynamic>.from(map['attributes'] ?? {}),
    );
  }
}
