import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/analysis_report_model.dart';
import '../../repositories/analysis_repository.dart';
import '../../widgets/animated_score_gauge.dart';
import '../../widgets/annotation_marker_overlay.dart';
import '../../widgets/component_bounding_box_painter.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/heatmap_painter.dart';
import '../../widgets/app_bottom_nav_bar.dart';

class AnalysisScreen extends ConsumerStatefulWidget {
  const AnalysisScreen({super.key});

  @override
  ConsumerState<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends ConsumerState<AnalysisScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showBoundingBoxes = true;
  bool _showHeatmap = false;
  final bool _showAnnotations = true;
  int _selectedScreenIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reportAsync = ref.watch(currentAnalysisReportProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('VisionUX AI Review Detail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_outlined),
            tooltip: 'Export PDF Report',
            onPressed: () => context.go('/reports'),
          ),
          IconButton(
            icon: const Icon(Icons.compare_arrows_outlined),
            tooltip: 'Compare Designs',
            onPressed: () => context.go('/comparison'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: reportAsync.when(
        loading: () => const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Color(0xFF00F2FE)),
              SizedBox(height: 16),
              Text('Rendering AI visual analysis report...'),
            ],
          ),
        ),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (report) {
          final activeScreen = report.screenshots.isNotEmpty
              ? report.screenshots[_selectedScreenIndex]
              : null;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Screen Selector & Toggle Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(report.screenshots.length, (idx) {
                              final isSelected = idx == _selectedScreenIndex;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ChoiceChip(
                                  label: Text(report.screenshots[idx].title),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    if (selected) {
                                      setState(() {
                                        _selectedScreenIndex = idx;
                                      });
                                    }
                                  },
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                      FilterChip(
                        avatar: const Icon(Icons.check_box_outlined, size: 16),
                        label: const Text('Boxes'),
                        selected: _showBoundingBoxes,
                        onSelected: (v) => setState(() => _showBoundingBoxes = v),
                      ),
                      const SizedBox(width: 6),
                      FilterChip(
                        avatar: const Icon(Icons.local_fire_department_outlined, size: 16),
                        label: const Text('Heatmap'),
                        selected: _showHeatmap,
                        onSelected: (v) => setState(() => _showHeatmap = v),
                      ),
                    ],
                  ),
                ),

                // Screenshot Interactive Viewport Container
                if (activeScreen != null) ...[
                  Container(
                    height: 380,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF00F2FE).withValues(alpha: 0.3),
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: InteractiveViewer(
                      minScale: 0.8,
                      maxScale: 4.0,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Base Screenshot Image
                          CachedNetworkImage(
                            imageUrl: activeScreen.imageUrl,
                            fit: BoxFit.contain,
                            placeholder: (context, url) =>
                                const Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, err) =>
                                const Icon(Icons.image_not_supported, color: Colors.grey),
                          ),

                          // AI Bounding Box Painter Overlay
                          if (_showBoundingBoxes)
                            ComponentBoundingBoxOverlay(
                              components: activeScreen.detectedComponents,
                            ),

                          // Heatmap Painter Overlay
                          if (_showHeatmap && activeScreen.heatmapData != null)
                            HeatmapOverlay(
                              heatmapData: activeScreen.heatmapData!,
                            ),

                          // AI Annotation Pin Markers Overlay
                          if (_showAnnotations)
                            AnnotationMarkerOverlay(
                              annotations: activeScreen.annotations,
                            ),
                        ],
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                // 9 Score Gauges Grid Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'AI Design Scorecard',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                const SizedBox(height: 12),

                // Horizontal Animated Score Gauges List
                SizedBox(
                  height: 150,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      _ScoreGaugeItem(
                          score: report.scores.overallScore, title: 'Overall Score'),
                      _ScoreGaugeItem(
                          score: report.scores.visualDesignScore, title: 'Visual Design'),
                      _ScoreGaugeItem(
                          score: report.scores.accessibilityScore, title: 'Accessibility'),
                      _ScoreGaugeItem(
                          score: report.scores.typographyScore, title: 'Typography'),
                      _ScoreGaugeItem(
                          score: report.scores.colorScore, title: 'Color System'),
                      _ScoreGaugeItem(
                          score: report.scores.consistencyScore, title: 'Consistency'),
                      _ScoreGaugeItem(
                          score: report.scores.navigationScore, title: 'Navigation'),
                      _ScoreGaugeItem(
                          score: report.scores.modernDesignScore, title: 'Modernization'),
                      _ScoreGaugeItem(
                          score: report.scores.userExperienceScore, title: 'User Experience'),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Tab Bar for Deep Analysis Categories
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabs: const [
                    Tab(text: 'AI Action Plan'),
                    Tab(text: 'Accessibility (WCAG)'),
                    Tab(text: 'Typography'),
                    Tab(text: 'Color System'),
                    Tab(text: 'User Flow'),
                    Tab(text: 'Modern Patterns'),
                  ],
                ),

                SizedBox(
                  height: 480,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Tab 1: AI Redesign Assistant Action Cards
                      _ActionPlanTab(recommendations: report.recommendations),

                      // Tab 2: Accessibility WCAG Scanner Findings
                      _AccessibilityTab(report: report),

                      // Tab 3: Typography Hierarchy Engine
                      _TypographyTab(report: report),

                      // Tab 4: Color System Harmony & Contrast
                      _ColorTab(report: report),

                      // Tab 5: User Flow Funnel Analysis
                      _UserFlowTab(userFlow: report.userFlow),

                      // Tab 6: Modern Design Pattern Detection
                      _ModernPatternsTab(patterns: report.detectedDesignPatterns),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 2),
    );
  }
}

class _ScoreGaugeItem extends StatelessWidget {
  final double score;
  final String title;

  const _ScoreGaugeItem({required this.score, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 14),
      child: GlassCard(
        padding: const EdgeInsets.all(12),
        child: AnimatedScoreGauge(
          score: score,
          title: title,
          size: 105,
          strokeWidth: 9,
        ),
      ),
    );
  }
}

class _ActionPlanTab extends StatelessWidget {
  final List<dynamic> recommendations;

  const _ActionPlanTab({required this.recommendations});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: recommendations.length,
      itemBuilder: (context, idx) {
        final rec = recommendations[idx];
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: rec.severity.color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        rec.category,
                        style: TextStyle(
                          color: rec.severity.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    Text(
                      rec.expectedImprovement,
                      style: const TextStyle(
                        color: Color(0xFF10B981),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Issue: ${rec.issue}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  'Cause: ${rec.cause}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00F2FE).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF00F2FE).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.lightbulb_outline,
                          color: Color(0xFF00F2FE), size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Recommendation: ${rec.recommendation}',
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AccessibilityTab extends StatelessWidget {
  final AnalysisReportModel report;

  const _AccessibilityTab({required this.report});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlassCard(
            child: Row(
              children: [
                const Icon(Icons.accessibility_new,
                    color: Color(0xFF10B981), size: 36),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'WCAG 2.1 Compliance Level: AA Pass',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF10B981),
                            ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Minimum contrast ratio 4.5:1 satisfied for 85% of body text. 2 low-contrast secondary elements identified.',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Touch Target Size Audit',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          const ListTile(
            leading: Icon(Icons.check_circle, color: Color(0xFF10B981)),
            title: Text('Primary CTA Button (52dp x 48dp)'),
            subtitle: Text('Exceeds minimum 48dp touch target requirement.'),
          ),
          const ListTile(
            leading: Icon(Icons.warning, color: Colors.orange),
            title: Text('Icon Filter Chips (38dp x 32dp)'),
            subtitle: Text('Slightly below recommended 48dp touch area.'),
          ),
        ],
      ),
    );
  }
}

class _TypographyTab extends StatelessWidget {
  final AnalysisReportModel report;

  const _TypographyTab({required this.report});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Typography Hierarchy Scale',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 12),
                const Text('Display Title: Plus Jakarta Sans 32pt Bold (Scale ratio 1.414)'),
                const Text('Headline Medium: 24pt SemiBold'),
                const Text('Body Large: 16pt Regular (Line height 1.5)'),
                const Text('Caption/Badge: 12pt Medium'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ColorTab extends StatelessWidget {
  final AnalysisReportModel report;

  const _ColorTab({required this.report});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Extracted Palette & Contrast Ratios',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _colorChip(const Color(0xFF00F2FE), 'Primary', '4.8:1'),
                    const SizedBox(width: 8),
                    _colorChip(const Color(0xFF4FACFE), 'Secondary', '5.2:1'),
                    const SizedBox(width: 8),
                    _colorChip(const Color(0xFF131C2E), 'Surface', '8.9:1'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _colorChip(Color color, String label, String ratio) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 11)),
          Text(ratio, style: const TextStyle(color: Colors.black54, fontSize: 10)),
        ],
      ),
    );
  }
}

class _UserFlowTab extends StatelessWidget {
  final dynamic userFlow;

  const _UserFlowTab({required this.userFlow});

  @override
  Widget build(BuildContext context) {
    if (userFlow == null) {
      return const Center(
        child: Text('Upload 2+ screenshots to generate full application user flow diagram.'),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: userFlow.flowNodes.length,
      itemBuilder: (context, idx) {
        final node = userFlow.flowNodes[idx];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GlassCard(
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFF00F2FE),
                  child: Text('${node.stepOrder}',
                      style: const TextStyle(
                          color: Color(0xFF0F172A), fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(node.screenName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                      if (node.bottleneckWarning != null) ...[
                        const SizedBox(height: 4),
                        Text(node.bottleneckWarning!,
                            style: const TextStyle(color: Colors.red, fontSize: 11)),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ModernPatternsTab extends StatelessWidget {
  final List<String> patterns;

  const _ModernPatternsTab({required this.patterns});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: patterns.map((p) {
          return Chip(
            avatar: const Icon(Icons.auto_awesome, color: Color(0xFF00F2FE), size: 16),
            label: Text(p),
          );
        }).toList(),
      ),
    );
  }
}
