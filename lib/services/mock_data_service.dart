import '../config/app_constants.dart';
import '../models/user_model.dart';
import '../models/project_model.dart';
import '../models/score_breakdown_model.dart';
import '../models/analysis_report_model.dart';
import '../models/comparison_model.dart';
import '../services/ai_visual_analysis_engine.dart';

class MockDataService {
  static final MockDataService instance = MockDataService._();
  MockDataService._();

  UserModel get sampleUser => UserModel(
        id: 'usr_demo_101',
        email: 'alex.designer@visionux.ai',
        displayName: 'Alex Rivers',
        photoUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        totalAnalyses: 14,
        avgDesignScore: 87.4,
      );

  List<ProjectModel> get sampleProjects => [
        ProjectModel(
          id: 'proj_fintech_01',
          userId: 'usr_demo_101',
          name: 'Apex Mobile Banking App',
          description: 'Next-gen fintech banking dashboard & investment portfolio screen flow.',
          platform: TargetPlatformType.mobile,
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          updatedAt: DateTime.now().subtract(const Duration(hours: 4)),
          screenCount: 4,
          latestOverallScore: 89.2,
          coverImageUrl: 'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=600',
        ),
        ProjectModel(
          id: 'proj_ecommerce_02',
          userId: 'usr_demo_101',
          name: 'Lumina Fashion E-Commerce',
          description: 'Minimalist Web & Mobile shop front, product page & checkout flow.',
          platform: TargetPlatformType.web,
          createdAt: DateTime.now().subtract(const Duration(days: 8)),
          updatedAt: DateTime.now().subtract(const Duration(days: 1)),
          screenCount: 6,
          latestOverallScore: 85.8,
          coverImageUrl: 'https://images.unsplash.com/photo-1472851294608-062f824d29cc?w=600',
        ),
        ProjectModel(
          id: 'proj_saas_03',
          userId: 'usr_demo_101',
          name: 'NeuralStudio AI SaaS Platform',
          description: 'Desktop SaaS dashboard, analytics timeline & settings panel.',
          platform: TargetPlatformType.desktop,
          createdAt: DateTime.now().subtract(const Duration(days: 18)),
          updatedAt: DateTime.now().subtract(const Duration(days: 5)),
          screenCount: 3,
          latestOverallScore: 92.4,
          coverImageUrl: 'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=600',
        ),
      ];

  Future<AnalysisReportModel> getSampleReport(String projectId) async {
    final project = sampleProjects.firstWhere(
      (p) => p.id == projectId,
      orElse: () => sampleProjects.first,
    );

    final mockImages = [
      'https://images.unsplash.com/photo-1616469829941-c7200edec809?w=1080',
      'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=1080',
      'https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=1080',
    ];

    return await AIVisualAnalysisEngine.instance.analyzeProjectScreenshots(
      projectId: project.id,
      userId: project.userId,
      projectName: project.name,
      imagePathsOrUrls: mockImages,
      platform: project.platform,
    );
  }

  List<ComparisonModel> get sampleComparisons => [
        ComparisonModel(
          id: 'comp_1',
          title: 'Apex Banking V1 vs V2 Redesign',
          description: 'Side-by-side analysis after applying 8pt grid system & WCAG contrast fixes.',
          designAId: 'v1',
          designAName: 'Apex Banking V1 (Legacy)',
          designAImageUrl: 'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=600',
          designAScores: const ScoreBreakdownModel(
            overallScore: 74.2,
            visualDesignScore: 75.0,
            accessibilityScore: 68.0,
            typographyScore: 72.0,
            colorScore: 76.0,
            consistencyScore: 70.0,
            navigationScore: 80.0,
            modernDesignScore: 78.0,
            userExperienceScore: 74.5,
          ),
          designBId: 'v2',
          designBName: 'Apex Banking V2 (VisionUX AI Fixed)',
          designBImageUrl: 'https://images.unsplash.com/photo-1616469829941-c7200edec809?w=600',
          designBScores: const ScoreBreakdownModel(
            overallScore: 89.2,
            visualDesignScore: 88.5,
            accessibilityScore: 82.0,
            typographyScore: 86.0,
            colorScore: 89.0,
            consistencyScore: 84.5,
            navigationScore: 91.0,
            modernDesignScore: 93.0,
            userExperienceScore: 87.5,
          ),
          overallDelta: 15.0,
          keyDifferences: [
            'Contrast ratio improved from 3.1:1 to 5.4:1 (WCAG AA Pass).',
            'Enforced 8-point uniform padding system.',
            'CTA button touch target expanded to 52dp.',
            'Modern Glassmorphism card backdrop introduced.'
          ],
          winnerDesignName: 'Apex Banking V2 (VisionUX AI Fixed)',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ];
}
