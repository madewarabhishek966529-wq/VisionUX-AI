import 'score_breakdown_model.dart';
import 'recommendation_model.dart';
import 'screenshot_model.dart';
import 'user_flow_model.dart';

class AnalysisReportModel {
  final String id;
  final String projectId;
  final String userId;
  final String projectName;
  final DateTime analyzedAt;
  final ScoreBreakdownModel scores;
  final List<RecommendationModel> recommendations;
  final List<ScreenshotModel> screenshots;
  final UserFlowAnalysisModel? userFlow;
  final List<String> detectedDesignPatterns; // e.g. Material Design 3, Glassmorphism
  final String summaryText;

  const AnalysisReportModel({
    required this.id,
    required this.projectId,
    required this.userId,
    required this.projectName,
    required this.analyzedAt,
    required this.scores,
    required this.recommendations,
    required this.screenshots,
    this.userFlow,
    required this.detectedDesignPatterns,
    required this.summaryText,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'projectId': projectId,
      'userId': userId,
      'projectName': projectName,
      'analyzedAt': analyzedAt.toIso8601String(),
      'scores': scores.toMap(),
      'recommendations': recommendations.map((e) => e.toMap()).toList(),
      'screenshots': screenshots.map((e) => e.toMap()).toList(),
      'userFlow': userFlow?.toMap(),
      'detectedDesignPatterns': detectedDesignPatterns,
      'summaryText': summaryText,
    };
  }

  factory AnalysisReportModel.fromMap(Map<String, dynamic> map, String docId) {
    return AnalysisReportModel(
      id: docId,
      projectId: map['projectId'] ?? '',
      userId: map['userId'] ?? '',
      projectName: map['projectName'] ?? 'Project Analysis',
      analyzedAt: map['analyzedAt'] != null
          ? DateTime.parse(map['analyzedAt'])
          : DateTime.now(),
      scores: ScoreBreakdownModel.fromMap(map['scores'] ?? {}),
      recommendations: (map['recommendations'] as List<dynamic>?)
              ?.map((e) => RecommendationModel.fromMap(e))
              .toList() ??
          [],
      screenshots: (map['screenshots'] as List<dynamic>?)
              ?.map((e) => ScreenshotModel.fromMap(e, e['id'] ?? ''))
              .toList() ??
          [],
      userFlow: map['userFlow'] != null
          ? UserFlowAnalysisModel.fromMap(map['userFlow'])
          : null,
      detectedDesignPatterns:
          (map['detectedDesignPatterns'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList() ??
              [],
      summaryText: map['summaryText'] ?? '',
    );
  }
}
