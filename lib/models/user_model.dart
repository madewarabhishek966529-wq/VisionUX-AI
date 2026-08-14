class UserModel {
  final String id;
  final String email;
  final String displayName;
  final String? photoUrl;
  final DateTime createdAt;
  final int totalAnalyses;
  final double avgDesignScore;

  const UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoUrl,
    required this.createdAt,
    this.totalAnalyses = 0,
    this.avgDesignScore = 0.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'createdAt': createdAt.toIso8601String(),
      'totalAnalyses': totalAnalyses,
      'avgDesignScore': avgDesignScore,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map, String docId) {
    return UserModel(
      id: docId,
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? 'User',
      photoUrl: map['photoUrl'],
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      totalAnalyses: map['totalAnalyses'] ?? 0,
      avgDesignScore: (map['avgDesignScore'] ?? 0.0).toDouble(),
    );
  }
}
