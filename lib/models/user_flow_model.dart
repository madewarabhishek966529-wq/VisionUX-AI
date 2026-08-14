class UserFlowNode {
  final String id;
  final String screenName;
  final String screenshotUrl;
  final int stepOrder;
  final String? bottleneckWarning;

  const UserFlowNode({
    required this.id,
    required this.screenName,
    required this.screenshotUrl,
    required this.stepOrder,
    this.bottleneckWarning,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'screenName': screenName,
      'screenshotUrl': screenshotUrl,
      'stepOrder': stepOrder,
      'bottleneckWarning': bottleneckWarning,
    };
  }

  factory UserFlowNode.fromMap(Map<String, dynamic> map) {
    return UserFlowNode(
      id: map['id'] ?? '',
      screenName: map['screenName'] ?? 'Screen',
      screenshotUrl: map['screenshotUrl'] ?? '',
      stepOrder: map['stepOrder'] ?? 0,
      bottleneckWarning: map['bottleneckWarning'],
    );
  }
}

class UserFlowAnalysisModel {
  final List<UserFlowNode> flowNodes;
  final int totalSteps;
  final int redundantStepsCount;
  final String navigationFrictionLevel; // Low, Medium, High
  final List<String> optimizationRecommendations;

  const UserFlowAnalysisModel({
    required this.flowNodes,
    required this.totalSteps,
    required this.redundantStepsCount,
    required this.navigationFrictionLevel,
    required this.optimizationRecommendations,
  });

  Map<String, dynamic> toMap() {
    return {
      'flowNodes': flowNodes.map((e) => e.toMap()).toList(),
      'totalSteps': totalSteps,
      'redundantStepsCount': redundantStepsCount,
      'navigationFrictionLevel': navigationFrictionLevel,
      'optimizationRecommendations': optimizationRecommendations,
    };
  }

  factory UserFlowAnalysisModel.fromMap(Map<String, dynamic> map) {
    return UserFlowAnalysisModel(
      flowNodes: (map['flowNodes'] as List<dynamic>?)
              ?.map((e) => UserFlowNode.fromMap(e))
              .toList() ??
          [],
      totalSteps: map['totalSteps'] ?? 0,
      redundantStepsCount: map['redundantStepsCount'] ?? 0,
      navigationFrictionLevel: map['navigationFrictionLevel'] ?? 'Low',
      optimizationRecommendations:
          (map['optimizationRecommendations'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList() ??
              [],
    );
  }
}
