import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/analysis_report_model.dart';
import 'project_repository.dart';

final selectedProjectIdProvider = StateProvider<String>((ref) => 'proj_fintech_01');

final currentAnalysisReportProvider = FutureProvider<AnalysisReportModel>((ref) async {
  final firestore = ref.watch(firestoreServiceProvider);
  final projectId = ref.watch(selectedProjectIdProvider);
  return firestore.fetchAnalysisReport(projectId);
});
