import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/project_model.dart';
import '../models/analysis_report_model.dart';
import '../models/comparison_model.dart';
import 'mock_data_service.dart';

class FirestoreService {
  final FirebaseFirestore? _db;

  FirestoreService() : _db = _tryGetFirestore();

  static FirebaseFirestore? _tryGetFirestore() {
    try {
      return FirebaseFirestore.instance;
    } catch (e) {
      debugPrint('Firestore not initialized, operating in Fallback Mock Mode: $e');
      return null;
    }
  }

  // --- Projects Collection ---
  Future<List<ProjectModel>> fetchUserProjects(String userId) async {
    final db = _db;
    if (db == null) {
      return MockDataService.instance.sampleProjects;
    }
    try {
      final snap = await db
          .collection('projects')
          .where('userId', isEqualTo: userId)
          .orderBy('updatedAt', descending: true)
          .get();
      return snap.docs
          .map((doc) => ProjectModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      debugPrint('Firestore fetch error, returning mock projects: $e');
      return MockDataService.instance.sampleProjects;
    }
  }

  Future<void> saveProject(ProjectModel project) async {
    final db = _db;
    if (db != null) {
      await db.collection('projects').doc(project.id).set(project.toMap());
    }
  }

  // --- Analysis Reports Collection ---
  Future<void> saveAnalysisReport(AnalysisReportModel report) async {
    final db = _db;
    if (db != null) {
      await db
          .collection('analysis_reports')
          .doc(report.id)
          .set(report.toMap());
    }
  }

  Future<AnalysisReportModel> fetchAnalysisReport(String projectId) async {
    final db = _db;
    if (db == null) {
      return await MockDataService.instance.getSampleReport(projectId);
    }
    try {
      final snap = await db
          .collection('analysis_reports')
          .where('projectId', isEqualTo: projectId)
          .limit(1)
          .get();

      if (snap.docs.isNotEmpty) {
        return AnalysisReportModel.fromMap(
            snap.docs.first.data(), snap.docs.first.id);
      }
      return await MockDataService.instance.getSampleReport(projectId);
    } catch (e) {
      return await MockDataService.instance.getSampleReport(projectId);
    }
  }

  // --- Comparisons Collection ---
  Future<List<ComparisonModel>> fetchComparisons(String userId) async {
    final db = _db;
    if (db == null) {
      return MockDataService.instance.sampleComparisons;
    }
    try {
      final snap = await db.collection('comparisons').get();
      return snap.docs
          .map((doc) => ComparisonModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      return MockDataService.instance.sampleComparisons;
    }
  }
}
