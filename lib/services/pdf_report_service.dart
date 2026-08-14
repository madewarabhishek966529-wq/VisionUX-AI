import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/analysis_report_model.dart';

class PdfReportService {
  static final PdfReportService instance = PdfReportService._();
  PdfReportService._();

  Future<Uint8List> generateReportPdf(AnalysisReportModel report) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            // Header Title
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'VisionUX AI',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.cyan900,
                      ),
                    ),
                    pw.Text(
                      'Intelligent UI/UX Design Audit Report',
                      style: const pw.TextStyle(
                        fontSize: 12,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ],
                ),
                pw.Text(
                  report.analyzedAt.toString().split(' ')[0],
                  style: const pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.grey600,
                  ),
                ),
              ],
            ),
            pw.Divider(thickness: 1, color: PdfColors.cyan700),
            pw.SizedBox(height: 16),

            // Executive Summary
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Project: ${report.projectName}',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    report.summaryText,
                    style: const pw.TextStyle(fontSize: 11),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 20),

            // Score Overview Grid
            pw.Text(
              'AI Scoring Breakdown',
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 8),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey300),
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.cyan50),
                  children: [
                    _cell('Category Metric', isHeader: true),
                    _cell('Score', isHeader: true),
                    _cell('Status', isHeader: true),
                  ],
                ),
                _scoreRow('Overall Design Rating', report.scores.overallScore),
                _scoreRow('Visual & Layout Design', report.scores.visualDesignScore),
                _scoreRow('WCAG Accessibility', report.scores.accessibilityScore),
                _scoreRow('Typography & Hierarchy', report.scores.typographyScore),
                _scoreRow('Color Harmony & Contrast', report.scores.colorScore),
                _scoreRow('Design System Consistency', report.scores.consistencyScore),
                _scoreRow('Navigation & Friction', report.scores.navigationScore),
                _scoreRow('Modernization Score', report.scores.modernDesignScore),
                _scoreRow('User Experience (UX)', report.scores.userExperienceScore),
              ],
            ),
            pw.SizedBox(height: 24),

            // AI Recommendations Action Plan
            pw.Text(
              'AI Redesign Action Plan',
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 8),
            ...report.recommendations.map((rec) {
              return pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 10),
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: pw.BorderRadius.circular(6),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      '${rec.severity.label.toUpperCase()}: ${rec.issue}',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 11,
                        color: rec.severity.name == 'critical'
                            ? PdfColors.red800
                            : PdfColors.orange800,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text('Root Cause: ${rec.cause}', style: const pw.TextStyle(fontSize: 10)),
                    pw.Text('Recommendation: ${rec.recommendation}',
                        style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                    pw.Text('Impact: ${rec.expectedImprovement}',
                        style: const pw.TextStyle(fontSize: 10, color: PdfColors.green800)),
                  ],
                ),
              );
            }),
          ];
        },
      ),
    );

    return pdf.save();
  }

  pw.Widget _cell(String text, {bool isHeader = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 10,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  pw.TableRow _scoreRow(String label, double score) {
    String status = score >= 85 ? 'Excellent' : (score >= 75 ? 'Good' : 'Needs Review');
    return pw.TableRow(
      children: [
        _cell(label),
        _cell('${score.toStringAsFixed(1)} / 100'),
        _cell(status),
      ],
    );
  }

  Future<void> shareOrPrintReport(AnalysisReportModel report) async {
    final pdfBytes = await generateReportPdf(report);
    await Printing.sharePdf(
      bytes: pdfBytes,
      filename: '${report.projectName.replaceAll(' ', '_')}_VisionUX_Report.pdf',
    );
  }
}
