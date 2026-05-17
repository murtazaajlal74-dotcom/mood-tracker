import 'dart:math';
import 'package:flutter/material.dart';

/// Draws mood faces purely on a Canvas using Flutter's drawing primitives.
/// No images, no emoji, no icon fonts — only drawCircle, drawArc, drawLine,
/// drawOval, and drawPath.

class MoodFacePainter extends CustomPainter {
  final String mood;

  const MoodFacePainter({required this.mood});

  // Paint helpers

  Paint _fill(Color color) => Paint()
    ..color = color
    ..style = PaintingStyle.fill;

  Paint _stroke(Color color, double width) => Paint()
    ..color = color
    ..style = PaintingStyle.stroke
    ..strokeWidth = width
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  // Entry point

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.42; // face radius

    switch (mood) {
      case 'happy':
        _drawHappy(canvas, cx, cy, r);
        break;
      case 'neutral':
        _drawNeutral(canvas, cx, cy, r);
        break;
      case 'sad':
        _drawSad(canvas, cx, cy, r);
        break;
      case 'excited':
        _drawExcited(canvas, cx, cy, r);
        break;
      case 'angry':
        _drawAngry(canvas, cx, cy, r);
        break;
      default:
        _drawNeutral(canvas, cx, cy, r);
    }
  }

  //  HAPPY
  // Yellow face · big arc smile · rosy cheeks · round dot eyes

  void _drawHappy(Canvas canvas, double cx, double cy, double r) {
    final eyeOff = r * 0.30;
    final eyeR = r * 0.10;
    final eyeY = cy - r * 0.18;

    // Head (filled circle + coloured outline)
    canvas.drawCircle(Offset(cx, cy), r, _fill(const Color(0xFFFFD93D)));
    canvas.drawCircle(
        Offset(cx, cy), r, _stroke(const Color(0xFFE8B400), r * 0.055));

    // Eyes — two solid dark circles
    canvas.drawCircle(
        Offset(cx - eyeOff, eyeY), eyeR, _fill(const Color(0xFF2C2C2C)));
    canvas.drawCircle(
        Offset(cx + eyeOff, eyeY), eyeR, _fill(const Color(0xFF2C2C2C)));

    // Smile — large upward arc
    canvas.drawArc(
      Rect.fromCenter(
          center: Offset(cx, cy + r * 0.05), width: r * 0.76, height: r * 0.50),
      0.20, // start slightly right of 0°
      pi - 0.40, // sweep nearly half-circle clockwise (= smile along bottom)
      false,
      _stroke(const Color(0xFF2C2C2C), r * 0.07),
    );

    // Rosy cheeks — semi-transparent pink circles
    canvas.drawCircle(Offset(cx - eyeOff - r * 0.06, cy + r * 0.17), r * 0.15,
        _fill(const Color(0x55FF7878)));
    canvas.drawCircle(Offset(cx + eyeOff + r * 0.06, cy + r * 0.17), r * 0.15,
        _fill(const Color(0x55FF7878)));
  }

  //  NEUTRAL
  // Blue face · flat line mouth · horizontal straight eyebrows
  void _drawNeutral(Canvas canvas, double cx, double cy, double r) {
    final eyeOff = r * 0.30;
    final eyeR = r * 0.10;
    final eyeY = cy - r * 0.18;

    // Head
    canvas.drawCircle(Offset(cx, cy), r, _fill(const Color(0xFFA8D8EA)));
    canvas.drawCircle(
        Offset(cx, cy), r, _stroke(const Color(0xFF5B8FA8), r * 0.055));

    // Eyes
    canvas.drawCircle(
        Offset(cx - eyeOff, eyeY), eyeR, _fill(const Color(0xFF2C2C2C)));
    canvas.drawCircle(
        Offset(cx + eyeOff, eyeY), eyeR, _fill(const Color(0xFF2C2C2C)));

    // Flat horizontal eyebrows
    final browPaint = _stroke(const Color(0xFF444444), r * 0.058);
    canvas.drawLine(
      Offset(cx - eyeOff - eyeR, eyeY - eyeR * 2.3),
      Offset(cx - eyeOff + eyeR, eyeY - eyeR * 2.3),
      browPaint,
    );
    canvas.drawLine(
      Offset(cx + eyeOff - eyeR, eyeY - eyeR * 2.3),
      Offset(cx + eyeOff + eyeR, eyeY - eyeR * 2.3),
      browPaint,
    );

    // Flat mouth — a single horizontal line
    canvas.drawLine(
      Offset(cx - r * 0.28, cy + r * 0.28),
      Offset(cx + r * 0.28, cy + r * 0.28),
      _stroke(const Color(0xFF2C2C2C), r * 0.07),
    );
  }

  // SAD

  // Purple face · frown arc · inner-corner-up eyebrows · teardrop Path
  void _drawSad(Canvas canvas, double cx, double cy, double r) {
    final eyeOff = r * 0.30;
    final eyeR = r * 0.10;
    final eyeY = cy - r * 0.14; // eyes sit a little lower when sad

    // Head
    canvas.drawCircle(Offset(cx, cy), r, _fill(const Color(0xFFC3B1E1)));
    canvas.drawCircle(
        Offset(cx, cy), r, _stroke(const Color(0xFF7B5EA7), r * 0.055));

    // Eyes
    canvas.drawCircle(
        Offset(cx - eyeOff, eyeY), eyeR, _fill(const Color(0xFF2C2C2C)));
    canvas.drawCircle(
        Offset(cx + eyeOff, eyeY), eyeR, _fill(const Color(0xFF2C2C2C)));

    // Eyebrows — inner corners higher than outer corners (classic sad shape)
    final browPaint = _stroke(const Color(0xFF444444), r * 0.058);
    // Left brow: outer-low → inner-high
    canvas.drawLine(
      Offset(cx - eyeOff - eyeR, eyeY - eyeR * 1.6),
      Offset(cx - eyeOff + eyeR, eyeY - eyeR * 2.9),
      browPaint,
    );
    // Right brow: inner-high → outer-low
    canvas.drawLine(
      Offset(cx + eyeOff - eyeR, eyeY - eyeR * 2.9),
      Offset(cx + eyeOff + eyeR, eyeY - eyeR * 1.6),
      browPaint,
    );


    canvas.drawArc(
      Rect.fromCenter(
          center: Offset(cx, cy + r * 0.56), width: r * 0.64, height: r * 0.40),
      pi + 0.25,
      pi - 0.50,
      false,
      _stroke(const Color(0xFF2C2C2C), r * 0.07),
    );

    // Teardrop using drawPath — cubic bézier curves form the droplet shape
    final tx = cx - eyeOff + eyeR * 0.3;
    final ty = eyeY + eyeR * 2.2;
    final tearPath = Path()
      ..moveTo(tx, ty)
      ..cubicTo(
          tx - eyeR, ty + eyeR, tx - eyeR, ty + eyeR * 2.5, tx, ty + eyeR * 2.8)
      ..cubicTo(tx + eyeR, ty + eyeR * 2.5, tx + eyeR, ty + eyeR, tx, ty);
    canvas.drawPath(tearPath, _fill(const Color(0x996699FF)));
  }

  //  EXCITED
  // Orange face · wide eyes with glimmer · raised arched eyebrows · open mouth
  void _drawExcited(Canvas canvas, double cx, double cy, double r) {
    final eyeOff = r * 0.30;
    final eyeR = r * 0.13; // eyes are bigger than normal
    final eyeY = cy - r * 0.18;

    // Head
    canvas.drawCircle(Offset(cx, cy), r, _fill(const Color(0xFFFFB347)));
    canvas.drawCircle(
        Offset(cx, cy), r, _stroke(const Color(0xFFE74C3C), r * 0.055));

    // Big round eyes
    canvas.drawCircle(
        Offset(cx - eyeOff, eyeY), eyeR, _fill(const Color(0xFF2C2C2C)));
    canvas.drawCircle(
        Offset(cx + eyeOff, eyeY), eyeR, _fill(const Color(0xFF2C2C2C)));

    // White glimmer dots inside eyes
    canvas.drawCircle(Offset(cx - eyeOff - eyeR * 0.3, eyeY - eyeR * 0.3),
        eyeR * 0.40, _fill(Colors.white));
    canvas.drawCircle(Offset(cx + eyeOff - eyeR * 0.3, eyeY - eyeR * 0.3),
        eyeR * 0.40, _fill(Colors.white));

    // Raised arched eyebrows — upward arc above each eye
    final browPaint = _stroke(const Color(0xFF2C2C2C), r * 0.058);
    canvas.drawArc(
      Rect.fromCenter(
          center: Offset(cx - eyeOff, eyeY - eyeR * 3.0),
          width: eyeR * 2.6,
          height: eyeR * 1.6),
      pi + 0.30,
      pi - 0.60,
      false,
      browPaint,
    );
    canvas.drawArc(
      Rect.fromCenter(
          center: Offset(cx + eyeOff, eyeY - eyeR * 3.0),
          width: eyeR * 2.6,
          height: eyeR * 1.6),
      pi + 0.30,
      pi - 0.60,
      false,
      browPaint,
    );

    // Open mouth — a filled D-shape (arc + closed chord)
    final mouthRect = Rect.fromCenter(
        center: Offset(cx, cy + r * 0.12), width: r * 0.70, height: r * 0.50);
    final mouthPath = Path()..addArc(mouthRect, 0.10, pi - 0.20);
    mouthPath.close(); // straight line across the top closes the D shape
    canvas.drawPath(mouthPath, _fill(const Color(0xFF7B2D00)));
    // Outline the arc only
    canvas.drawArc(mouthRect, 0.10, pi - 0.20, false,
        _stroke(const Color(0xFF2C2C2C), r * 0.05));
  }

  //  ANGRY
  // Red face · narrowed oval eyes · V-shaped red eyebrows · frown · vein Path
  void _drawAngry(Canvas canvas, double cx, double cy, double r) {
    final eyeOff = r * 0.30;
    final eyeR = r * 0.10;
    final eyeY = cy - r * 0.18;

    // Head
    canvas.drawCircle(Offset(cx, cy), r, _fill(const Color(0xFFFF6B6B)));
    canvas.drawCircle(
        Offset(cx, cy), r, _stroke(const Color(0xFFC0392B), r * 0.055));

    // Narrowed eyes — drawn as flat ovals using drawOval
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(cx - eyeOff, eyeY),
          width: eyeR * 2.4,
          height: eyeR * 1.3),
      _fill(const Color(0xFF2C2C2C)),
    );
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(cx + eyeOff, eyeY),
          width: eyeR * 2.4,
          height: eyeR * 1.3),
      _fill(const Color(0xFF2C2C2C)),
    );

    // V-shaped angry eyebrows — inner corners point DOWN, outer corners point UP
    final browPaint = _stroke(const Color(0xFFC0392B), r * 0.08);
    // Left brow: outer-high → inner-low
    canvas.drawLine(
      Offset(cx - eyeOff - eyeR, eyeY - eyeR * 2.6),
      Offset(cx - eyeOff + eyeR, eyeY - eyeR * 1.2),
      browPaint,
    );
    // Right brow: inner-low → outer-high
    canvas.drawLine(
      Offset(cx + eyeOff - eyeR, eyeY - eyeR * 1.2),
      Offset(cx + eyeOff + eyeR, eyeY - eyeR * 2.6),
      browPaint,
    );

    // Frown — same technique as the sad face
    canvas.drawArc(
      Rect.fromCenter(
          center: Offset(cx, cy + r * 0.56), width: r * 0.56, height: r * 0.34),
      pi + 0.30,
      pi - 0.60,
      false,
      _stroke(const Color(0xFF2C2C2C), r * 0.07),
    );

    // Anger vein — small zigzag Path near the temple
    final veinPath = Path()
      ..moveTo(cx + r * 0.50, cy - r * 0.56)
      ..lineTo(cx + r * 0.60, cy - r * 0.72)
      ..lineTo(cx + r * 0.70, cy - r * 0.56);
    canvas.drawPath(veinPath, _stroke(const Color(0xFFC0392B), r * 0.045));
  }

  @override
  bool shouldRepaint(MoodFacePainter oldDelegate) => oldDelegate.mood != mood;
}
