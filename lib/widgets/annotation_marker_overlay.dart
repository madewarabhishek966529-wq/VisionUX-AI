import 'package:flutter/material.dart';
import '../models/annotation_marker_model.dart';

class AnnotationMarkerOverlay extends StatelessWidget {
  final List<AnnotationMarkerModel> annotations;
  final Function(AnnotationMarkerModel)? onMarkerTap;

  const AnnotationMarkerOverlay({
    super.key,
    required this.annotations,
    this.onMarkerTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;

        return Stack(
          children: annotations.map((ann) {
            final dx = ann.position.dx * w;
            final dy = ann.position.dy * h;

            return Positioned(
              left: dx - 16,
              top: dy - 16,
              child: GestureDetector(
                onTap: () {
                  if (onMarkerTap != null) {
                    onMarkerTap!(ann);
                  } else {
                    _showMarkerDialog(context, ann);
                  }
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: ann.color,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: ann.color.withValues(alpha: 0.6),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  void _showMarkerDialog(BuildContext context, AnnotationMarkerModel ann) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: ann.color.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.error_outline, color: ann.color),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      ann.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                ann.description,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Got it'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
