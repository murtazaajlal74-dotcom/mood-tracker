import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/mood_provider.dart';
import 'timeline_card.dart';

/// Horizontally scrollable row of the last 7 mood entries.
class TimelineSection extends ConsumerWidget {
  const TimelineSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(moodProvider);
    // Take only the last 7 entries to display
    final last7 = entries.length > 7 ? entries.sublist(entries.length - 7) : entries;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section label
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 14),
            child: Text(
              'PAST 7 ENTRIES',
              style: TextStyle(
                fontSize: 11,
                letterSpacing: 3,
                fontWeight: FontWeight.w700,
                color: Colors.white.withOpacity(0.38),
              ),
            ),
          ),

          // Empty state
          if (last7.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'No entries yet — tap a mood above to get started!',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.30),
                ),
              ),
            )
          else
            // Horizontally scrollable list of TimelineCards
            SizedBox(
              height: 168,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: last7.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, idx) {
                  final fullIndex = entries.length - last7.length + idx;
                  return TimelineCard(
                    entry: last7[idx],
                    index: fullIndex,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
