import 'package:flutter/material.dart';
import '../models/heatmap_data_model.dart';

class HeatmapOverlay extends StatelessWidget {
  final HeatmapDataModel heatmapData;

  const HeatmapOverlay({
    super.key,
    required this.heatmapData,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: _HeatmapPainter(heatmapData: heatmapData),
    );
  }
}

class _HeatmapPainter extends CustomPainter {
  final HeatmapDataModel heatmapData;

  _HeatmapPainter({required this.heatmapData});

  @override
  void paint(Canvas canvas, Size size) {
    for (final point in heatmapData.points) {
      final center = Offset(
        point.position.dx * size.width,
        point.position.dy * size.height,
      );

      final radius = point.radius;

      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.red.withValues(alpha: 0.70 * point.intensity),
            Colors.orange.withValues(alpha: 0.50 * point.intensity),
            Colors.yellow.withValues(alpha: 0.30 * point.intensity),
            Colors.blue.withValues(alpha: 0.10 * point.intensity),
            Colors.transparent,
          ],
          stops: const [0.0, 0.3, 0.6, 0.85, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: radius));

      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _HeatmapPainter oldDelegate) {
    return oldDelegate.heatmapData != heatmapData;
  }
}
