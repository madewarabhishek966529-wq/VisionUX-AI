import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/glass_card.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  double _aiSensitivity = 0.85;
  String _wcagLevel = 'WCAG 2.1 AA';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Engine & Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'AI Detection Sensitivity',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    value: _aiSensitivity,
                    min: 0.5,
                    max: 1.0,
                    divisions: 10,
                    activeColor: const Color(0xFF00F2FE),
                    label: '${(_aiSensitivity * 100).toInt()}%',
                    onChanged: (val) {
                      setState(() {
                        _aiSensitivity = val;
                      });
                    },
                  ),
                  Text(
                    'Current threshold: ${(_aiSensitivity * 100).toInt()}% confidence',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Accessibility Compliance Standard',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  DropdownButton<String>(
                    value: _wcagLevel,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(
                        value: 'WCAG 2.1 AA',
                        child: Text('WCAG 2.1 Level AA (Standard - 4.5:1 ratio)'),
                      ),
                      DropdownMenuItem(
                        value: 'WCAG 2.1 AAA',
                        child: Text('WCAG 2.1 Level AAA (Strict - 7:1 ratio)'),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _wcagLevel = val;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            GlassCard(
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Firebase Services Connected & Active',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
