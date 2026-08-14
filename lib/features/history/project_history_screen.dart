import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../repositories/project_repository.dart';
import '../../repositories/analysis_repository.dart';
import '../../widgets/glass_card.dart';

class ProjectHistoryScreen extends ConsumerWidget {
  const ProjectHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(userProjectsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Project History Timeline'),
      ),
      body: projectsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (projects) {
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: projects.length,
            itemBuilder: (context, idx) {
              final p = projects[idx];
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: GlassCard(
                  onTap: () {
                    ref.read(selectedProjectIdProvider.notifier).state = p.id;
                    context.go('/analysis');
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFF00F2FE).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(p.platform.icon, color: const Color(0xFF00F2FE)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${p.screenCount} screens • ${p.updatedAt.toString().split(' ')[0]}',
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00F2FE).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${p.latestOverallScore} pts',
                          style: const TextStyle(
                            color: Color(0xFF00F2FE),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
