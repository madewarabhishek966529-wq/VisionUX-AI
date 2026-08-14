import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/project_model.dart';
import '../services/firestore_service.dart';
import 'auth_repository.dart';

final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

final userProjectsProvider = FutureProvider<List<ProjectModel>>((ref) async {
  final firestore = ref.watch(firestoreServiceProvider);
  final user = ref.watch(currentUserProvider);
  return firestore.fetchUserProjects(user?.id ?? 'usr_demo_101');
});
