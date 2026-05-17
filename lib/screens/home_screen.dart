import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/mood_data.dart';
import '../models/mood_entry.dart';
import '../providers/mood_provider.dart';
import '../widgets/mood_face.dart';
import '../widgets/mood_selector.dart';
import '../widgets/timeline_section.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(moodProvider);
    final selectedIdx = ref.watch(selectedEntryProvider);

    // Safely resolve the selected entry
    final MoodEntry? selectedEntry =
        (selectedIdx != null && selectedIdx < entries.length)
            ? entries[selectedIdx]
            : null;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0C29),
      body: Container(
        // Full-screen dark gradient background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F0C29), Color(0xFF1A1A2E), Color(0xFF16213E)],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            // Keep layout readable on wide desktop screens
            constraints: const BoxConstraints(maxWidth: 620),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //  Header
                  _Header(),
                  const SizedBox(height: 4),

                  // Mood selector (5 tappable faces)
                  const MoodSelector(),

                  // Thin gradient divider
                  _Divider(),
                  const SizedBox(height: 20),

                  //  Horizontal timeline
                  const TimelineSection(),
                  const SizedBox(height: 8),

                  //  Selected entry detail panel (animated in/out)
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 320),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    transitionBuilder: (child, anim) => FadeTransition(
                      opacity: anim,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.12),
                          end: Offset.zero,
                        ).animate(anim),
                        child: child,
                      ),
                    ),
                    child: selectedEntry != null
                        ? _SelectedDetail(
                            key: ValueKey(selectedIdx),
                            entry: selectedEntry,
                            onClose: () => ref
                                .read(selectedEntryProvider.notifier)
                                .state = null,
                          )
                        : const SizedBox(height: 16, key: ValueKey('empty')),
                  ),

                  const SizedBox(height: 28),

                  // Footer label
                  Text(
                    'ALL FACES DRAWN WITH CUSTOMPAINT · NO IMAGES · NO EMOJI',
                    style: TextStyle(
                      fontSize: 9,
                      letterSpacing: 1.8,
                      fontWeight: FontWeight.w700,
                      color: Colors.white.withOpacity(0.18),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Header

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final dateStr =
        '${weekdays[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 52, 24, 24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.07)),
        ),
      ),
      child: Column(
        children: [
          Text(
            'HOW ARE YOU FEELING?',
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 4,
              fontWeight: FontWeight.w700,
              color: Colors.white.withOpacity(0.40),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Mood Tracker',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            dateStr,
            style:
                TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.35)),
          ),
        ],
      ),
    );
  }
}

//  Divider

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        height: 1,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              Colors.white.withOpacity(0.16),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}

//  Selected Entry Detail Panel

class _SelectedDetail extends StatelessWidget {
  final MoodEntry entry;
  final VoidCallback onClose;

  const _SelectedDetail(
      {super.key, required this.entry, required this.onClose});

  String _formatDate(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[dt.month - 1]} ${dt.day}';
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour < 12 ? 'AM' : 'PM';
    return '$h:$m $ampm';
  }

  @override
  Widget build(BuildContext context) {
    final cfg = getMoodConfig(entry.mood);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [cfg.color.withOpacity(0.11), cfg.accent.withOpacity(0.07)],
          ),
          border: Border.all(color: cfg.color.withOpacity(0.45), width: 1.5),
          boxShadow: [
            BoxShadow(color: cfg.color.withOpacity(0.18), blurRadius: 28),
          ],
        ),
        child: Row(
          children: [
            // Face
            MoodFace(mood: entry.mood, size: 66),
            const SizedBox(width: 18),

            // Text info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SELECTED ENTRY',
                    style: TextStyle(
                      fontSize: 9,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w700,
                      color: Colors.white.withOpacity(0.40),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    cfg.label,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: cfg.color,
                    ),
                  ),
                  Text(
                    '${_formatDate(entry.dateTime)}  ·  ${_formatTime(entry.dateTime)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.48),
                    ),
                  ),
                ],
              ),
            ),

            // Close button
            GestureDetector(
              onTap: onClose,
              child: Icon(Icons.close_rounded,
                  color: Colors.white.withOpacity(0.30), size: 22),
            ),
          ],
        ),
      ),
    );
  }
}
