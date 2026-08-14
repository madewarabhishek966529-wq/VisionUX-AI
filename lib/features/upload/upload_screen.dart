import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/app_constants.dart';
import '../../repositories/analysis_repository.dart';
import '../../repositories/auth_repository.dart';
import '../../services/ai_visual_analysis_engine.dart';

import '../../widgets/glass_card.dart';
import '../../widgets/app_bottom_nav_bar.dart';

class UploadScreen extends ConsumerStatefulWidget {
  const UploadScreen({super.key});

  @override
  ConsumerState<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends ConsumerState<UploadScreen> {
  final _projectNameController =
      TextEditingController(text: 'Apex Banking V2 Redesign');
  TargetPlatformType _selectedPlatform = TargetPlatformType.mobile;
  List<String> _selectedImageFiles = [
    'https://images.unsplash.com/photo-1616469829941-c7200edec809?w=1080',
    'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=1080',
  ];
  bool _isAnalyzing = false;
  double _analysisProgress = 0.0;
  String _statusText = '';

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg', 'webp'],
      allowMultiple: true,
    );

    if (result != null && result.paths.isNotEmpty) {
      setState(() {
        _selectedImageFiles =
            result.paths.where((p) => p != null).cast<String>().toList();
      });
    }
  }

  Future<void> _startAiAnalysis() async {
    if (_selectedImageFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least 1 screenshot.')),
      );
      return;
    }

    setState(() {
      _isAnalyzing = true;
      _analysisProgress = 0.1;
      _statusText = 'Pre-processing & compressing UI screenshots...';
    });

    await Future.delayed(const Duration(milliseconds: 600));
    setState(() {
      _analysisProgress = 0.35;
      _statusText = 'AI detecting UI components (Buttons, Cards, NavBars)...';
    });

    await Future.delayed(const Duration(milliseconds: 700));
    setState(() {
      _analysisProgress = 0.65;
      _statusText = 'Scanning WCAG 2.1 contrast ratios & typography hierarchy...';
    });

    await Future.delayed(const Duration(milliseconds: 600));
    setState(() {
      _analysisProgress = 0.90;
      _statusText = 'Simulating visual heatmaps & calculating score matrix...';
    });

    final user = ref.read(currentUserProvider);
    final report = await AIVisualAnalysisEngine.instance.analyzeProjectScreenshots(
      projectId: 'proj_${DateTime.now().millisecondsSinceEpoch}',
      userId: user?.id ?? 'usr_demo_101',
      projectName: _projectNameController.text.trim(),
      imagePathsOrUrls: _selectedImageFiles,
      platform: _selectedPlatform,
    );

    ref.read(selectedProjectIdProvider.notifier).state = report.projectId;

    if (mounted) {
      setState(() {
        _isAnalyzing = false;
      });
      context.go('/analysis');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New UI/UX Audit'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project Information Form Card
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Project & Source Details',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _projectNameController,
                    decoration: const InputDecoration(
                      labelText: 'Project Name',
                      prefixIcon: Icon(Icons.folder_open_outlined),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Target Platform Source',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: TargetPlatformType.values.map((p) {
                      final isSelected = p == _selectedPlatform;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedPlatform = p;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF00F2FE).withValues(alpha: 0.15)
                                  : Theme.of(context).colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF00F2FE)
                                    : Theme.of(context).colorScheme.outline,
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  p.icon,
                                  color: isSelected
                                      ? const Color(0xFF00F2FE)
                                      : Colors.grey,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  p.label,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Drop Area / Picker Card
            GlassCard(
              onTap: _pickFiles,
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF00F2FE).withValues(alpha: 0.15),
                    ),
                    child: const Icon(
                      Icons.cloud_upload_outlined,
                      size: 44,
                      color: Color(0xFF00F2FE),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Upload App Screenshots',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Supports PNG, JPG, JPEG, WebP • Single/Multi screen flow',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: _pickFiles,
                    icon: const Icon(Icons.add_photo_alternate_outlined),
                    label: const Text('Browse Files'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Selected Screenshots Preview List
            if (_selectedImageFiles.isNotEmpty) ...[
              Text(
                'Selected Screens (${_selectedImageFiles.length})',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _selectedImageFiles.length,
                  itemBuilder: (context, index) {
                    final path = _selectedImageFiles[index];
                    return Stack(
                      children: [
                        Container(
                          width: 80,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF00F2FE).withValues(alpha: 0.4),
                            ),
                            image: DecorationImage(
                              image: NetworkImage(path),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 16,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedImageFiles.removeAt(index);
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close,
                                  size: 14, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Progress / Submit Container
            if (_isAnalyzing) ...[
              GlassCard(
                child: Column(
                  children: [
                    LinearProgressIndicator(
                      value: _analysisProgress,
                      color: const Color(0xFF00F2FE),
                      backgroundColor: Colors.white.withValues(alpha: 0.1),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _statusText,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ] else ...[
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _startAiAnalysis,
                  icon: const Icon(Icons.auto_awesome),
                  label: const Text('Start VisionUX AI Audit'),
                ),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 1),
    );
  }
}
