import '../config/app_constants.dart';

class RecommendationModel {
  final String id;
  final String issue;
  final String cause;
  final String recommendation;
  final String expectedImprovement;
  final RecommendationSeverity severity;
  final String category; // e.g. Typography, Color, Spacing, Accessibility

  const RecommendationModel({
    required this.id,
    required this.issue,
    required this.cause,
    required this.recommendation,
    required this.expectedImprovement,
    required this.severity,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'issue': issue,
      'cause': cause,
      'recommendation': recommendation,
      'expectedImprovement': expectedImprovement,
      'severity': severity.name,
      'category': category,
    };
  }

  factory RecommendationModel.fromMap(Map<String, dynamic> map) {
    return RecommendationModel(
      id: map['id'] ?? '',
      issue: map['issue'] ?? '',
      cause: map['cause'] ?? '',
      recommendation: map['recommendation'] ?? '',
      expectedImprovement: map['expectedImprovement'] ?? '',
      severity: RecommendationSeverity.values.firstWhere(
        (e) => e.name == map['severity'],
        orElse: () => RecommendationSeverity.warning,
      ),
      category: map['category'] ?? 'General',
    );
  }
}
