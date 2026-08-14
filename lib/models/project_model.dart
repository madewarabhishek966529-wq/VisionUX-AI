import '../config/app_constants.dart';

class ProjectModel {
  final String id;
  final String userId;
  final String name;
  final String description;
  final TargetPlatformType platform;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int screenCount;
  final double latestOverallScore;
  final String? coverImageUrl;

  const ProjectModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    required this.platform,
    required this.createdAt,
    required this.updatedAt,
    this.screenCount = 0,
    this.latestOverallScore = 0.0,
    this.coverImageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'description': description,
      'platform': platform.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'screenCount': screenCount,
      'latestOverallScore': latestOverallScore,
      'coverImageUrl': coverImageUrl,
    };
  }

  factory ProjectModel.fromMap(Map<String, dynamic> map, String docId) {
    return ProjectModel(
      id: docId,
      userId: map['userId'] ?? '',
      name: map['name'] ?? 'Untitled Project',
      description: map['description'] ?? '',
      platform: TargetPlatformType.values.firstWhere(
        (e) => e.name == map['platform'],
        orElse: () => TargetPlatformType.mobile,
      ),
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : DateTime.now(),
      screenCount: map['screenCount'] ?? 0,
      latestOverallScore: (map['latestOverallScore'] ?? 0.0).toDouble(),
      coverImageUrl: map['coverImageUrl'],
    );
  }
}
