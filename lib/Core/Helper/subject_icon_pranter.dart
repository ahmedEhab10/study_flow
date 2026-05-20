import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:study_flow/Core/Models/Subject_Model.dart';

class SubjectIconWidget extends StatelessWidget {
  final SubjectIcon icon;
  final Color color;
  final double size;

  const SubjectIconWidget({
    super.key,
    required this.icon,
    required this.color,
    this.size = 28,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _SubjectIconPainter(icon: icon, color: color),
    );
  }
}

class _SubjectIconPainter extends CustomPainter {
  final SubjectIcon icon;
  final Color color;

  _SubjectIconPainter({required this.icon, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = size.width * 0.08
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    switch (icon) {
      case SubjectIcon.biology:
        _drawBiology(canvas, size, paint, fill);
        break;
      case SubjectIcon.physics:
        _drawPhysics(canvas, size, paint, fill);
        break;
      case SubjectIcon.history:
        _drawHistory(canvas, size, paint, fill);
        break;
      case SubjectIcon.mathematics:
        _drawMathematics(canvas, size, paint, fill);
        break;
      case SubjectIcon.chemistry:
        _drawChemistry(canvas, size, paint, fill);
        break;
      case SubjectIcon.literature:
        _drawLiterature(canvas, size, paint, fill);
        break;
      case SubjectIcon.geography:
        _drawGeography(canvas, size, paint, fill);
        break;
      case SubjectIcon.computerScience:
        _drawComputerScience(canvas, size, paint, fill);
        break;
    }
  }

  // Biology: DNA double helix
  void _drawBiology(Canvas canvas, Size s, Paint p, Paint f) {
    final cx = s.width / 2;
    final startY = s.height * 0.15;
    final endY = s.height * 0.85;
    final height = endY - startY;

    final double cycles = 1.5;
    final double totalAngle = cycles * 2 * 3.14159265;

    final path1 = Path();
    final path2 = Path();

    final int pointsCount = 40;
    final amplitude = s.width * 0.22;

    for (int i = 0; i <= pointsCount; i++) {
      final double t = i / pointsCount;
      final double y = startY + t * height;
      final double angle = t * totalAngle;

      final double dx = amplitude * math.sin(angle);
      final double x1 = cx + dx;
      final double x2 = cx - dx;

      if (i == 0) {
        path1.moveTo(x1, y);
        path2.moveTo(x2, y);
      } else {
        path1.lineTo(x1, y);
        path2.lineTo(x2, y);
      }
    }

    canvas.drawPath(path1, p);
    canvas.drawPath(path2, p);

    // rungs
    final rungPaint = Paint()
      ..color = p.color.withValues(alpha: 0.6)
      ..strokeWidth = p.strokeWidth * 0.7
      ..strokeCap = StrokeCap.round;

    final List<double> rungTValues = [0.166, 0.5, 0.833];
    for (final double t in rungTValues) {
      final double y = startY + t * height;
      final double angle = t * totalAngle;
      final double dx = amplitude * math.sin(angle);
      final double x1 = cx + dx;
      final double x2 = cx - dx;

      canvas.drawLine(Offset(x1, y), Offset(x2, y), rungPaint);
    }
  }

  // Physics: atom
  void _drawPhysics(Canvas canvas, Size s, Paint p, Paint f) {
    final cx = s.width / 2;
    final cy = s.height / 2;
    final rx = s.width * 0.42;
    final ry = s.height * 0.18;

    for (int i = 0; i < 3; i++) {
      canvas.save();
      canvas.translate(cx, cy);
      canvas.rotate(i * 3.14159 / 3);
      canvas.drawOval(
        Rect.fromCenter(center: Offset.zero, width: rx * 2, height: ry * 2),
        p,
      );
      canvas.restore();
    }

    // nucleus
    canvas.drawCircle(Offset(cx, cy), s.width * 0.08, f);
  }

  // History: hourglass / scroll
  void _drawHistory(Canvas canvas, Size s, Paint p, Paint f) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        s.width * 0.15,
        s.height * 0.08,
        s.width * 0.7,
        s.height * 0.84,
      ),
      Radius.circular(s.width * 0.1),
    );
    canvas.drawRRect(rect, p);

    // lines inside (scroll text)
    final linePaint = Paint()
      ..color = p.color
      ..strokeWidth = p.strokeWidth * 0.7
      ..strokeCap = StrokeCap.round;

    for (double y = 0.28; y <= 0.72; y += 0.16) {
      canvas.drawLine(
        Offset(s.width * 0.28, s.height * y),
        Offset(s.width * 0.72, s.height * y),
        linePaint,
      );
    }

    // top curl
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(s.width * 0.5, s.height * 0.08),
        width: s.width * 0.7,
        height: s.height * 0.18,
      ),
      3.14159,
      3.14159,
      false,
      p,
    );
  }

  // Mathematics: integral / sigma
  void _drawMathematics(Canvas canvas, Size s, Paint p, Paint f) {
    // Sigma symbol
    final path = Path();
    path.moveTo(s.width * 0.75, s.height * 0.15);
    path.lineTo(s.width * 0.2, s.height * 0.15);
    path.lineTo(s.width * 0.58, s.height * 0.5);
    path.lineTo(s.width * 0.2, s.height * 0.85);
    path.lineTo(s.width * 0.75, s.height * 0.85);
    canvas.drawPath(path, p);
  }

  // Chemistry: flask / beaker
  void _drawChemistry(Canvas canvas, Size s, Paint p, Paint f) {
    final path = Path();
    path.moveTo(s.width * 0.35, s.height * 0.1);
    path.lineTo(s.width * 0.35, s.height * 0.45);
    path.lineTo(s.width * 0.12, s.height * 0.88);
    path.lineTo(s.width * 0.88, s.height * 0.88);
    path.lineTo(s.width * 0.65, s.height * 0.45);
    path.lineTo(s.width * 0.65, s.height * 0.1);
    path.close();
    canvas.drawPath(path, p);

    // liquid fill inside
    final liquidPath = Path();
    liquidPath.moveTo(s.width * 0.19, s.height * 0.72);
    liquidPath.lineTo(s.width * 0.81, s.height * 0.72);
    liquidPath.lineTo(s.width * 0.88, s.height * 0.88);
    liquidPath.lineTo(s.width * 0.12, s.height * 0.88);
    liquidPath.close();
    canvas.drawPath(liquidPath, f..color = f.color.withValues(alpha: 0.35));

    // top stopper line
    canvas.drawLine(
      Offset(s.width * 0.28, s.height * 0.1),
      Offset(s.width * 0.72, s.height * 0.1),
      p,
    );

    // bubbles
    final bubblePaint = Paint()
      ..color = p.color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(s.width * 0.42, s.height * 0.63),
      s.width * 0.05,
      bubblePaint,
    );
    canvas.drawCircle(
      Offset(s.width * 0.62, s.height * 0.58),
      s.width * 0.035,
      bubblePaint,
    );
  }

  // Literature: open book
  void _drawLiterature(Canvas canvas, Size s, Paint p, Paint f) {
    // Left page
    final leftPage = Path();
    leftPage.moveTo(s.width * 0.5, s.height * 0.18);
    leftPage.cubicTo(
      s.width * 0.35,
      s.height * 0.14,
      s.width * 0.1,
      s.height * 0.2,
      s.width * 0.1,
      s.height * 0.25,
    );
    leftPage.lineTo(s.width * 0.1, s.height * 0.82);
    leftPage.cubicTo(
      s.width * 0.1,
      s.height * 0.85,
      s.width * 0.35,
      s.height * 0.8,
      s.width * 0.5,
      s.height * 0.84,
    );
    leftPage.close();
    canvas.drawPath(leftPage, p);

    // Right page
    final rightPage = Path();
    rightPage.moveTo(s.width * 0.5, s.height * 0.18);
    rightPage.cubicTo(
      s.width * 0.65,
      s.height * 0.14,
      s.width * 0.9,
      s.height * 0.2,
      s.width * 0.9,
      s.height * 0.25,
    );
    rightPage.lineTo(s.width * 0.9, s.height * 0.82);
    rightPage.cubicTo(
      s.width * 0.9,
      s.height * 0.85,
      s.width * 0.65,
      s.height * 0.8,
      s.width * 0.5,
      s.height * 0.84,
    );
    rightPage.close();
    canvas.drawPath(rightPage, p);

    // spine
    canvas.drawLine(
      Offset(s.width * 0.5, s.height * 0.18),
      Offset(s.width * 0.5, s.height * 0.84),
      p,
    );

    // lines on left
    final linePaint = Paint()
      ..color = p.color.withValues(alpha: 0.5)
      ..strokeWidth = p.strokeWidth * 0.6
      ..strokeCap = StrokeCap.round;
    for (double y = 0.35; y <= 0.68; y += 0.12) {
      canvas.drawLine(
        Offset(s.width * 0.18, s.height * y),
        Offset(s.width * 0.44, s.height * y),
        linePaint,
      );
    }
    // lines on right
    for (double y = 0.35; y <= 0.68; y += 0.12) {
      canvas.drawLine(
        Offset(s.width * 0.56, s.height * y),
        Offset(s.width * 0.82, s.height * y),
        linePaint,
      );
    }
  }

  // Geography: globe
  void _drawGeography(Canvas canvas, Size s, Paint p, Paint f) {
    final cx = s.width / 2;
    final cy = s.height / 2;
    final r = s.width * 0.42;

    // outer circle
    canvas.drawCircle(Offset(cx, cy), r, p);

    // vertical meridian
    canvas.drawLine(Offset(cx, cy - r), Offset(cx, cy + r), p);

    // horizontal equator
    canvas.drawLine(Offset(cx - r, cy), Offset(cx + r, cy), p);

    // ellipses for longitude curves
    canvas.save();
    canvas.clipRect(Rect.fromCircle(center: Offset(cx, cy), radius: r));
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy), width: r * 1.0, height: r * 2),
      p,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy), width: r * 1.7, height: r * 2),
      p,
    );
    canvas.restore();
  }

  // Computer Science: circuit / chip
  void _drawComputerScience(Canvas canvas, Size s, Paint p, Paint f) {
    // chip body
    final chipRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        s.width * 0.28,
        s.height * 0.28,
        s.width * 0.44,
        s.height * 0.44,
      ),
      Radius.circular(s.width * 0.06),
    );
    canvas.drawRRect(chipRect, p);

    // grid dots inside
    final dotPaint = Paint()
      ..color = p.color
      ..style = PaintingStyle.fill;
    for (double dx = 0.38; dx <= 0.62; dx += 0.12) {
      for (double dy = 0.38; dy <= 0.62; dy += 0.12) {
        canvas.drawCircle(
          Offset(s.width * dx, s.height * dy),
          s.width * 0.03,
          dotPaint,
        );
      }
    }

    // pins top/bottom
    final pinPaint = Paint()
      ..color = p.color
      ..strokeWidth = p.strokeWidth * 0.9
      ..strokeCap = StrokeCap.round;

    for (double x in [0.38, 0.5, 0.62]) {
      canvas.drawLine(
        Offset(s.width * x, s.height * 0.1),
        Offset(s.width * x, s.height * 0.28),
        pinPaint,
      );
      canvas.drawLine(
        Offset(s.width * x, s.height * 0.72),
        Offset(s.width * x, s.height * 0.9),
        pinPaint,
      );
    }

    // pins left/right
    for (double y in [0.38, 0.5, 0.62]) {
      canvas.drawLine(
        Offset(s.width * 0.1, s.height * y),
        Offset(s.width * 0.28, s.height * y),
        pinPaint,
      );
      canvas.drawLine(
        Offset(s.width * 0.72, s.height * y),
        Offset(s.width * 0.9, s.height * y),
        pinPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SubjectIconPainter oldDelegate) {
    return oldDelegate.icon != icon || oldDelegate.color != color;
  }
}
