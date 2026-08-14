import 'package:flutter/material.dart';
import '../models/component_detection_model.dart';

class ComponentBoundingBoxOverlay extends StatelessWidget {
  final List<ComponentDetectionModel> components;
  final bool showLabels;
  final String? selectedComponentId;
  final ValueChanged<ComponentDetectionModel>? onSelectComponent;

  const ComponentBoundingBoxOverlay({
    super.key,
    required this.components,
    this.showLabels = true,
    this.selectedComponentId,
    this.onSelectComponent,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;

        return Stack(
          children: components.map((c) {
            final isSelected = c.id == selectedComponentId;
            final rect = Rect.fromLTWH(
              c.boundingBox.left * w,
              c.boundingBox.top * h,
              c.boundingBox.width * w,
              c.boundingBox.height * h,
            );

            return Positioned(
              left: rect.left,
              top: rect.top,
              width: rect.width,
              height: rect.height,
              child: GestureDetector(
                onTap: () => onSelectComponent?.call(c),
                child: Container(
                  decoration: BoxDecoration(
                    color: c.type.color.withValues(alpha: isSelected ? 0.25 : 0.12),
                    border: Border.all(
                      color: isSelected ? Colors.white : c.type.color,
                      width: isSelected ? 2.5 : 1.5,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: showLabels
                      ? Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              left: 2,
                              top: -18,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: c.type.color,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '${c.type.label} (${(c.confidence * 100).toInt()}%)',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : null,
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
