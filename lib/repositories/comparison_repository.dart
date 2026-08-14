import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/comparison_model.dart';
import 'auth_repository.dart';
import 'project_repository.dart';

final comparisonsListProvider = FutureProvider<List<ComparisonModel>>((ref) async {
  final firestore = ref.watch(firestoreServiceProvider);
  final user = ref.watch(currentUserProvider);
  return firestore.fetchComparisons(user?.id ?? 'usr_demo_101');
});
