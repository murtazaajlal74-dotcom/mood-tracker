import 'dart:convert';

/// Represents a single logged mood entry.
class MoodEntry {
  final String mood;
  final DateTime dateTime;

  const MoodEntry({required this.mood, required this.dateTime});

  Map<String, dynamic> toJson() => {
        'mood': mood,
        'dateTime': dateTime.toIso8601String(),
      };

  factory MoodEntry.fromJson(Map<String, dynamic> json) => MoodEntry(
        mood: json['mood'] as String,
        dateTime: DateTime.parse(json['dateTime'] as String),
      );

  /// Encode to a JSON string for SharedPreferences storage.
  String encode() => jsonEncode(toJson());

  /// Decode from a JSON string.
  static MoodEntry decode(String str) =>
      MoodEntry.fromJson(jsonDecode(str) as Map<String, dynamic>);
}
