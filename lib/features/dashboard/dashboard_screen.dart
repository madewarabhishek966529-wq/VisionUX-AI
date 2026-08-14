import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/app_constants.dart';
import '../../repositories/auth_repository.dart';
import '../../repositories/project_repository.dart';
import '../../repositories/analysis_repository.dart';
import '../../widgets/animated_score_gauge.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/app_bottom_nav_bar.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final projectsAsync = ref.watch(userProjectsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF00F2FE), Color(0xFF4FACFE)],
                ),
              ),
              child: const Icon(Icons.remove_red_eye, color: Color(0xFF0F172A), size: 20),
            ),
            const SizedBox(width: 12),
            Text(AppConstants.appName),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.go('/settings'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: projectsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error loading projects: $err')),
        data: (projects) {
          final avgScore = projects.isNotEmpty
              ? projects.map((p) => p.latestOverallScore).reduce((a, b) => a + b) / projects.length
              : 87.4;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Banner Header
                GlassCard(
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: const Color(0xFF00F2FE),
                        child: Text(
                          (user?.displayName ?? 'A')[0].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome back, ${user?.displayName ?? 'Alex'} 👋',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '14 UI/UX analyses completed • 8pt spacing compliance high',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => context.go('/upload'),
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('New Audit'),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),

                const SizedBox(height: 24),

                // Metrics Grid Row
                Row(
                  children: [
                    Expanded(
                      child: GlassCard(
                        child: Column(
                          children: [
                            AnimatedScoreGauge(
                              score: avgScore,
                              title: 'Average Score',
                              size: 110,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Overall Portfolio Rating',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Score Trend History',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 100,
                              child: LineChart(
                                LineChartData(
                                  gridData: const FlGridData(show: false),
                                  titlesData: const FlTitlesData(show: false),
                                  borderData: FlBorderData(show: false),
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: const [
                                        FlSpot(0, 72),
                                        FlSpot(1, 78),
                                        FlSpot(2, 81),
                                        FlSpot(3, 85),
                                        FlSpot(4, 89),
                                      ],
                                      isCurved: true,
                                      color: const Color(0xFF00F2FE),
                                      barWidth: 3,
                                      isStrokeCapRound: true,
                                      dotData: const FlDotData(show: false),
                                      belowBarData: BarAreaData(
                                        show: true,
                                        color: const Color(0xFF00F2FE).withValues(alpha: 0.15),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // Quick Navigation Hub
                Row(
                  children: [
                    Expanded(
                      child: _QuickActionCard(
                        title: 'Run AI Audit',
                        subtitle: 'Upload single/multi screen',
                        icon: Icons.cloud_upload_outlined,
                        color: const Color(0xFF00F2FE),
                        onTap: () => context.go('/upload'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _QuickActionCard(
                        title: 'Compare Designs',
                        subtitle: 'Side-by-side delta',
                        icon: Icons.compare_arrows_outlined,
                        color: const Color(0xFF4FACFE),
                        onTap: () => context.go('/comparison'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _QuickActionCard(
                        title: 'Export PDF',
                        subtitle: 'Generate report',
                        icon: Icons.picture_as_pdf_outlined,
                        color: const Color(0xFF8B5CF6),
                        onTap: () => context.go('/reports'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // Recent Projects Carousel Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Projects (${projects.length})',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    TextButton(
                      onPressed: () => context.go('/history'),
                      child: const Text('View All'),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Recent Projects Horizontal ListView
                SizedBox(
                  height: 220,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: projects.length,
                    itemBuilder: (context, index) {
                      final p = projects[index];
                      return Container(
                        width: 260,
                        margin: const EdgeInsets.only(right: 16),
                        child: GlassCard(
                          onTap: () {
                            ref.read(selectedProjectIdProvider.notifier).state = p.id;
                            context.go('/analysis');
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(p.platform.icon, size: 18, color: const Color(0xFF00F2FE)),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      p.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                p.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const Spacer(),
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   Flexible(
                                     child: Text(
                                       '${p.screenCount} screens',
                                       maxLines: 1,
                                       overflow: TextOverflow.ellipsis,
                                       style: const TextStyle(fontSize: 11, color: Colors.grey),
                                     ),
                                   ),
                                   const SizedBox(width: 4),
                                   Container(
                                     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                     decoration: BoxDecoration(
                                       color: const Color(0xFF00F2FE).withValues(alpha: 0.15),
                                       borderRadius: BorderRadius.circular(12),
                                       border: Border.all(
                                         color: const Color(0xFF00F2FE).withValues(alpha: 0.4),
                                       ),
                                     ),
                                     child: Text(
                                       '${p.latestOverallScore} pts',
                                       style: const TextStyle(
                                         color: Color(0xFF00F2FE),
                                         fontWeight: FontWeight.bold,
                                         fontSize: 11,
                                       ),
                                     ),
                                   ),
                                 ],
                               ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 0),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
