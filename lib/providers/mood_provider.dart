import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/mood_entry.dart';

const _kStorageKey = 'mood_entries_v1';

//  Mood list notifier

/// Manages the list of mood entries.
/// On web, SharedPreferences writes to localStorage automatically.

class MoodNotifier extends StateNotifier<List<MoodEntry>> {
  MoodNotifier() : super([]) {
    _loadEntries();
  }

  /// Load persisted entries from SharedPreferences on startup.
  Future<void> _loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_kStorageKey) ?? [];
    state = raw.map(MoodEntry.decode).toList();
  }

  /// Add a new mood entry and persist. Keeps only the last 7.
  Future<void> addEntry(String mood) async {
    final entry = MoodEntry(mood: mood, dateTime: DateTime.now());
    final updated = [...state, entry];
    state = updated.length > 7 ? updated.sublist(updated.length - 7) : updated;
    await _saveEntries();
  }

  Future<void> _saveEntries() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_kStorageKey, state.map((e) => e.encode()).toList());
  }
}

/// The main provider — exposes the full list of mood entries.
final moodProvider = StateNotifierProvider<MoodNotifier, List<MoodEntry>>(
  (ref) => MoodNotifier(),
);

//  Selected entry provider

/// Stores the index (in [moodProvider]'s list) of the currently selected
/// timeline card, or null when nothing is selected.

final selectedEntryProvider = StateProvider<int?>((ref) => null);
