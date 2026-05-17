import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/mood_data.dart';
import '../providers/mood_provider.dart';
import 'mood_face.dart';

/// Row of tappable mood face buttons. Logs the chosen mood via [MoodNotifier].
class MoodSelector extends ConsumerStatefulWidget {
  const MoodSelector({super.key});

  @override
  ConsumerState<MoodSelector> createState() => _MoodSelectorState();
}

class _MoodSelectorState extends ConsumerState<MoodSelector> {
  String? _justLogged; // key of the mood that was just tapped (for glow effect)

  Future<void> _onTap(String moodKey) async {
    // Log the entry
    await ref.read(moodProvider.notifier).addEntry(moodKey);
    // Clear any selected timeline card
    ref.read(selectedEntryProvider.notifier).state = null;
    // Show brief glow
    setState(() => _justLogged = moodKey);
    await Future.delayed(const Duration(milliseconds: 650));
    if (mounted) setState(() => _justLogged = null);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 36, 24, 28),
      child: Column(
        children: [
          Text(
            'TAP TO LOG YOUR MOOD',
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 3,
              fontWeight: FontWeight.w700,
              color: Colors.white.withOpacity(0.40),
            ),
          ),
          const SizedBox(height: 28),
          Wrap(
            spacing: 18,
            runSpacing: 18,
            alignment: WrapAlignment.center,
            children: kMoods.map((m) {
              final active = _justLogged == m.key;
              return GestureDetector(
                onTap: () => _onTap(m.key),
                child: AnimatedScale(
                  scale: active ? 1.18 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  child: Column(
                    children: [
                      // Circular container around the face
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: active
                              ? m.color.withOpacity(0.28)
                              : Colors.white.withOpacity(0.06),
                          border: Border.all(
                            color: active
                                ? m.color
                                : Colors.white.withOpacity(0.12),
                            width: 2,
                          ),
                          boxShadow: active
                              ? [BoxShadow(color: m.color.withOpacity(0.55), blurRadius: 22)]
                              : [],
                        ),
                        child: MoodFace(mood: m.key, size: 62),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        m.label.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                          color: Colors.white.withOpacity(0.50),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
