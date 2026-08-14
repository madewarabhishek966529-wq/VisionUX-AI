import 'component_detection_model.dart';
import 'annotation_marker_model.dart';
import 'heatmap_data_model.dart';

class ScreenshotModel {
  final String id;
  final String projectId;
  final String title;
  final String imageUrl;
  final int width;
  final int height;
  final DateTime uploadedAt;
  final List<ComponentDetectionModel> detectedComponents;
  final List<AnnotationMarkerModel> annotations;
  final HeatmapDataModel? heatmapData;

  const ScreenshotModel({
    required this.id,
    required this.projectId,
    required this.title,
    required this.imageUrl,
    required this.width,
    required this.height,
    required this.uploadedAt,
    this.detectedComponents = const [],
    this.annotations = const [],
    this.heatmapData,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'projectId': projectId,
      'title': title,
      'imageUrl': imageUrl,
      'width': width,
      'height': height,
      'uploadedAt': uploadedAt.toIso8601String(),
      'detectedComponents': detectedComponents.map((e) => e.toMap()).toList(),
      'annotations': annotations.map((e) => e.toMap()).toList(),
      'heatmapData': heatmapData?.toMap(),
    };
  }

  factory ScreenshotModel.fromMap(Map<String, dynamic> map, String docId) {
    return ScreenshotModel(
      id: docId,
      projectId: map['projectId'] ?? '',
      title: map['title'] ?? 'Screenshot',
      imageUrl: map['imageUrl'] ?? '',
      width: map['width'] ?? 1080,
      height: map['height'] ?? 1920,
      uploadedAt: map['uploadedAt'] != null
          ? DateTime.parse(map['uploadedAt'])
          : DateTime.now(),
      detectedComponents: (map['detectedComponents'] as List<dynamic>?)
              ?.map((e) => ComponentDetectionModel.fromMap(e))
              .toList() ??
          [],
      annotations: (map['annotations'] as List<dynamic>?)
              ?.map((e) => AnnotationMarkerModel.fromMap(e))
              .toList() ??
          [],
      heatmapData: map['heatmapData'] != null
          ? HeatmapDataModel.fromMap(map['heatmapData'])
          : null,
    );
  }
}
