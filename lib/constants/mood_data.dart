import 'package:flutter/material.dart';

/// Configuration for each mood type.
class MoodConfig {
  final String key;
  final String label;
  final Color color; // primary face colour
  final Color accent; // outline / badge colour

  const MoodConfig({
    required this.key,
    required this.label,
    required this.color,
    required this.accent,
  });
}

const List<MoodConfig> kMoods = [
  MoodConfig(
      key: 'happy',
      label: 'Happy',
      color: Color(0xFFFFD93D),
      accent: Color(0xFFFF6B6B)),
  MoodConfig(
      key: 'neutral',
      label: 'Neutral',
      color: Color(0xFFA8D8EA),
      accent: Color(0xFF5B8FA8)),
  MoodConfig(
      key: 'sad',
      label: 'Sad',
      color: Color(0xFFC3B1E1),
      accent: Color(0xFF7B5EA7)),
  MoodConfig(
      key: 'excited',
      label: 'Excited',
      color: Color(0xFFFFB347),
      accent: Color(0xFFE74C3C)),
  MoodConfig(
      key: 'angry',
      label: 'Angry',
      color: Color(0xFFFF6B6B),
      accent: Color(0xFFC0392B)),
];

/// Returns the MoodConfig for [key], defaults to neutral if not found.

MoodConfig getMoodConfig(String key) =>
    kMoods.firstWhere((m) => m.key == key, orElse: () => kMoods[1]);
