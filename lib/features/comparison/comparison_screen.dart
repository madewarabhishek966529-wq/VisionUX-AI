import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../repositories/comparison_repository.dart';
import '../../widgets/animated_score_gauge.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/app_bottom_nav_bar.dart';

class ComparisonScreen extends ConsumerWidget {
  const ComparisonScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final comparisonsAsync = ref.watch(comparisonsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Design Comparison System'),
      ),
      body: comparisonsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (comparisons) {
          if (comparisons.isEmpty) {
            return const Center(child: Text('No comparisons generated yet.'));
          }

          final comp = comparisons.first;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Banner
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comp.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        comp.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFF10B981).withValues(alpha: 0.4),
                          ),
                        ),
                        child: Text(
                          '🏆 Winner: ${comp.winnerDesignName} (+${comp.overallDelta.toStringAsFixed(1)}% score gain)',
                          style: const TextStyle(
                            color: Color(0xFF10B981),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Side-by-Side Dual View Cards Row
                Row(
                  children: [
                    // Design A Card
                    Expanded(
                      child: GlassCard(
                        child: Column(
                          children: [
                            Text(
                              comp.designAName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 220,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade700),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: CachedNetworkImage(
                                imageUrl: comp.designAImageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 12),
                            AnimatedScoreGauge(
                              score: comp.designAScores.overallScore,
                              title: 'V1 Score',
                              size: 90,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 14),

                    // Design B Card
                    Expanded(
                      child: GlassCard(
                        borderColor: const Color(0xFF00F2FE),
                        child: Column(
                          children: [
                            Text(
                              comp.designBName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Color(0xFF00F2FE)),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 220,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: const Color(0xFF00F2FE)),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: CachedNetworkImage(
                                imageUrl: comp.designBImageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 12),
                            AnimatedScoreGauge(
                              score: comp.designBScores.overallScore,
                              title: 'V2 Score',
                              size: 90,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // Key Differences Checklist
                Text(
                  'Key AI Improvements Identified',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),

                ...comp.keyDifferences.map((diff) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: GlassCard(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle,
                              color: Color(0xFF10B981), size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              diff,
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 3),
    );
  }
}
