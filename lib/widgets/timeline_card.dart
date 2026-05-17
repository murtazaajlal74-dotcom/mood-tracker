import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/mood_entry.dart';
import '../constants/mood_data.dart';
import '../providers/mood_provider.dart';
import 'mood_face.dart';

/// A single card in the horizontal timeline.
/// Tapping it triggers a bounce animation and updates [selectedEntryProvider].
class TimelineCard extends ConsumerStatefulWidget {
  final MoodEntry entry;
  final int index; // index in the full moodProvider list

  const TimelineCard({super.key, required this.entry, required this.index});

  @override
  ConsumerState<TimelineCard> createState() => _TimelineCardState();
}

class _TimelineCardState extends ConsumerState<TimelineCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 480),
    );

    // Bounce: grow → overshoot → settle
    _scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.24), weight: 35),
      TweenSequenceItem(tween: Tween(begin: 1.24, end: 0.93), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.93, end: 1.00), weight: 35),
    ]).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onTap() {
    _ctrl.forward(from: 0); // play animation every tap
    ref.read(selectedEntryProvider.notifier).state = widget.index;
  }

  //  Helpers

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
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
    final cfg = getMoodConfig(widget.entry.mood);
    final isSelected = ref.watch(selectedEntryProvider) == widget.index;

    return GestureDetector(
      onTap: _onTap,
      child: ScaleTransition(
        scale: _scale,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 112,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white.withOpacity(0.06),
            border: Border.all(
              color: isSelected
                  ? cfg.color.withOpacity(0.80)
                  : Colors.white.withOpacity(0.09),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? cfg.color.withOpacity(0.35)
                    : Colors.black.withOpacity(0.30),
                blurRadius: isSelected ? 22 : 8,
                spreadRadius: isSelected ? 1 : 0,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //  Mood coloured accent bar at the top
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [cfg.color, cfg.accent],
                    ),
                  ),
                ),

                //  Card body
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
                  child: Column(
                    children: [
                      // The drawn face
                      MoodFace(mood: widget.entry.mood, size: 54),
                      const SizedBox(height: 8),

                      // Date
                      Text(
                        _formatDate(widget.entry.dateTime),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: cfg.color,
                        ),
                      ),

                      // Time
                      Text(
                        _formatTime(widget.entry.dateTime),
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.white.withOpacity(0.38),
                        ),
                      ),
                      const SizedBox(height: 7),

                      // Mood label badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 9, vertical: 2.5),
                        decoration: BoxDecoration(
                          color: cfg.color.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          cfg.label.toUpperCase(),
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.6,
                            color: cfg.accent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
