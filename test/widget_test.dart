import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visionux_ai/main.dart';
import 'package:visionux_ai/services/ai_visual_analysis_engine.dart';
import 'package:visionux_ai/config/app_constants.dart';

void main() {
  testWidgets('VisionUX AI app loads main dashboard', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: VisionUxApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text(AppConstants.appName), findsWidgets);
  });

  test('AI Visual Engine generates valid scores & report', () async {
    final report = await AIVisualAnalysisEngine.instance.analyzeProjectScreenshots(
      projectId: 'test_proj',
      userId: 'test_user',
      projectName: 'Test Project',
      imagePathsOrUrls: ['https://example.com/test.png'],
      platform: TargetPlatformType.mobile,
    );

    expect(report.scores.overallScore, greaterThan(0));
    expect(report.screenshots.length, equals(1));
    expect(report.recommendations.isNotEmpty, isTrue);
  });
}
