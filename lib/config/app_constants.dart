import 'package:flutter/material.dart';

enum TargetPlatformType {
  mobile('Mobile App', Icons.phone_iphone),
  web('Website', Icons.web),
  desktop('Desktop App', Icons.desktop_mac),
  figma('Figma Export', Icons.design_services);

  final String label;
  final IconData icon;
  const TargetPlatformType(this.label, this.icon);
}

enum ComponentType {
  button('Button', Icons.smart_button, Colors.blue),
  card('Card', Icons.card_membership, Colors.purple),
  iconElement('Icon', Icons.star, Colors.amber),
  menu('Menu', Icons.menu, Colors.cyan),
  textField('Text Field', Icons.text_fields, Colors.teal),
  navigationBar('Navigation Bar', Icons.navigation, Colors.indigo),
  bottomNav('Bottom Navigation', Icons.linear_scale, Colors.lightBlue),
  fab('Floating Action Button', Icons.add_circle, Colors.orange),
  appBar('App Bar', Icons.web_asset, Colors.deepPurple),
  image('Image / Media', Icons.image, Colors.pink);

  final String label;
  final IconData icon;
  final Color color;
  const ComponentType(this.label, this.icon, this.color);
}

enum WcagLevel {
  passAA('WCAG 2.1 AA Pass', Colors.green),
  passAAA('WCAG 2.1 AAA Pass', Colors.teal),
  warning('WCAG Warning', Colors.orange),
  fail('WCAG Non-Compliant', Colors.red);

  final String label;
  final Color color;
  const WcagLevel(this.label, this.color);
}

enum RecommendationSeverity {
  critical('Critical', Colors.red),
  warning('Warning', Colors.orange),
  info('Suggestion', Colors.blue);

  final String label;
  final Color color;
  const RecommendationSeverity(this.label, this.color);
}

class AppConstants {
  static const String appName = 'VisionUX AI';
  static const String appTagline = 'Intelligent UI/UX Design Reviewer';

  // Scoring Thresholds
  static const double minTouchTargetSizeDp = 48.0;
  static const double minNormalTextContrastRatio = 4.5;
  static const double minLargeTextContrastRatio = 3.0;

  // Modern Design Principles
  static const List<String> designSystems = [
    'Material Design 3',
    'Glassmorphism',
    'Minimalism',
    'Bento Layouts',
    'Card-based Interfaces',
    'Modern Mobile UX'
  ];
}
