import 'package:flutter/material.dart';
import '../painters/mood_face_painter.dart';

/// Thin widget that wraps [CustomPaint] + [MoodFacePainter].
/// Drop this anywhere you need to show a mood face.
class MoodFace extends StatelessWidget {
  final String mood;
  final double size;

  const MoodFace({super.key, required this.mood, required this.size});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: MoodFacePainter(mood: mood),
    );
  }
}
