import 'package:flutter/material.dart';

class HeatmapPoint {
  final Offset position; // Normalized 0.0 to 1.0
  final double intensity; // 0.0 to 1.0
  final double radius;

  const HeatmapPoint({
    required this.position,
    required this.intensity,
    this.radius = 40.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'position': [position.dx, position.dy],
      'intensity': intensity,
      'radius': radius,
    };
  }

  factory HeatmapPoint.fromMap(Map<String, dynamic> map) {
    final posList = (map['position'] as List<dynamic>?)
            ?.map((e) => (e as num).toDouble())
            .toList() ??
        [0.5, 0.5];

    return HeatmapPoint(
      position: Offset(posList[0], posList[1]),
      intensity: (map['intensity'] ?? 0.8).toDouble(),
      radius: (map['radius'] ?? 40.0).toDouble(),
    );
  }
}

class HeatmapDataModel {
  final List<HeatmapPoint> points;
  final String primaryCtaVisibility; // e.g. "High", "Optimal", "Low"
  final String attentionFlowSummary;

  const HeatmapDataModel({
    required this.points,
    required this.primaryCtaVisibility,
    required this.attentionFlowSummary,
  });

  Map<String, dynamic> toMap() {
    return {
      'points': points.map((p) => p.toMap()).toList(),
      'primaryCtaVisibility': primaryCtaVisibility,
      'attentionFlowSummary': attentionFlowSummary,
    };
  }

  factory HeatmapDataModel.fromMap(Map<String, dynamic> map) {
    return HeatmapDataModel(
      points: (map['points'] as List<dynamic>?)
              ?.map((e) => HeatmapPoint.fromMap(e))
              .toList() ??
          [],
      primaryCtaVisibility: map['primaryCtaVisibility'] ?? 'Optimal',
      attentionFlowSummary:
          map['attentionFlowSummary'] ?? 'User attention is balanced across key UI elements.',
    );
  }
}
