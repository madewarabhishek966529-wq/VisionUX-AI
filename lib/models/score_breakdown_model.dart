class ScoreBreakdownModel {
  final double overallScore;
  final double visualDesignScore;
  final double accessibilityScore;
  final double typographyScore;
  final double colorScore;
  final double consistencyScore;
  final double navigationScore;
  final double modernDesignScore;
  final double userExperienceScore;

  const ScoreBreakdownModel({
    required this.overallScore,
    required this.visualDesignScore,
    required this.accessibilityScore,
    required this.typographyScore,
    required this.colorScore,
    required this.consistencyScore,
    required this.navigationScore,
    required this.modernDesignScore,
    required this.userExperienceScore,
  });

  Map<String, dynamic> toMap() {
    return {
      'overallScore': overallScore,
      'visualDesignScore': visualDesignScore,
      'accessibilityScore': accessibilityScore,
      'typographyScore': typographyScore,
      'colorScore': colorScore,
      'consistencyScore': consistencyScore,
      'navigationScore': navigationScore,
      'modernDesignScore': modernDesignScore,
      'userExperienceScore': userExperienceScore,
    };
  }

  factory ScoreBreakdownModel.fromMap(Map<String, dynamic> map) {
    return ScoreBreakdownModel(
      overallScore: (map['overallScore'] ?? 0.0).toDouble(),
      visualDesignScore: (map['visualDesignScore'] ?? 0.0).toDouble(),
      accessibilityScore: (map['accessibilityScore'] ?? 0.0).toDouble(),
      typographyScore: (map['typographyScore'] ?? 0.0).toDouble(),
      colorScore: (map['colorScore'] ?? 0.0).toDouble(),
      consistencyScore: (map['consistencyScore'] ?? 0.0).toDouble(),
      navigationScore: (map['navigationScore'] ?? 0.0).toDouble(),
      modernDesignScore: (map['modernDesignScore'] ?? 0.0).toDouble(),
      userExperienceScore: (map['userExperienceScore'] ?? 0.0).toDouble(),
    );
  }
}
