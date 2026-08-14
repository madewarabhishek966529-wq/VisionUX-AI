import 'score_breakdown_model.dart';

class ComparisonModel {
  final String id;
  final String title;
  final String description;
  final String designAId;
  final String designAName;
  final String designAImageUrl;
  final ScoreBreakdownModel designAScores;
  final String designBId;
  final String designBName;
  final String designBImageUrl;
  final ScoreBreakdownModel designBScores;
  final double overallDelta; // Score difference e.g. +14.5%
  final List<String> keyDifferences;
  final String winnerDesignName;
  final DateTime createdAt;

  const ComparisonModel({
    required this.id,
    required this.title,
    required this.description,
    required this.designAId,
    required this.designAName,
    required this.designAImageUrl,
    required this.designAScores,
    required this.designBId,
    required this.designBName,
    required this.designBImageUrl,
    required this.designBScores,
    required this.overallDelta,
    required this.keyDifferences,
    required this.winnerDesignName,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'designAId': designAId,
      'designAName': designAName,
      'designAImageUrl': designAImageUrl,
      'designAScores': designAScores.toMap(),
      'designBId': designBId,
      'designBName': designBName,
      'designBImageUrl': designBImageUrl,
      'designBScores': designBScores.toMap(),
      'overallDelta': overallDelta,
      'keyDifferences': keyDifferences,
      'winnerDesignName': winnerDesignName,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ComparisonModel.fromMap(Map<String, dynamic> map, String docId) {
    return ComparisonModel(
      id: docId,
      title: map['title'] ?? 'Design Comparison',
      description: map['description'] ?? '',
      designAId: map['designAId'] ?? '',
      designAName: map['designAName'] ?? 'Original Design',
      designAImageUrl: map['designAImageUrl'] ?? '',
      designAScores: ScoreBreakdownModel.fromMap(map['designAScores'] ?? {}),
      designBId: map['designBId'] ?? '',
      designBName: map['designBName'] ?? 'Redesigned Version',
      designBImageUrl: map['designBImageUrl'] ?? '',
      designBScores: ScoreBreakdownModel.fromMap(map['designBScores'] ?? {}),
      overallDelta: (map['overallDelta'] ?? 0.0).toDouble(),
      keyDifferences: (map['keyDifferences'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      winnerDesignName: map['winnerDesignName'] ?? 'Redesigned Version',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
    );
  }
}
