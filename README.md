# 🎭 Mood Tracker — Flutter Web App

A single-screen mood tracker built with Flutter for the web.
All faces are drawn purely with `CustomPainter` (no images, no emoji).

---

## 📁 File Structure

```
mood_tracker/
├── pubspec.yaml
└── lib/
    ├── main.dart                        # App entry point + ProviderScope
    ├── constants/
    │   └── mood_data.dart               # MoodConfig list (key, label, color, accent)
    ├── models/
    │   └── mood_entry.dart              # MoodEntry model + JSON encode/decode
    ├── painters/
    │   └── mood_face_painter.dart       # ★ CustomPainter — draws all 5 faces
    ├── providers/
    │   └── mood_provider.dart           # Riverpod StateNotifier + SharedPreferences
    ├── widgets/
    │   ├── mood_face.dart               # Thin CustomPaint wrapper widget
    │   ├── mood_selector.dart           # 5 tappable mood buttons
    │   ├── timeline_card.dart           # Single timeline card with bounce animation
    │   └── timeline_section.dart        # Horizontal scrollable list of cards
    └── screens/
        └── home_screen.dart             # Main screen, wires everything together
```

---

## ⚙️ State Management — Riverpod

**Why Riverpod?**
- Compile-safe (no `context.read` misuse)
- Works perfectly on Flutter Web
- Clean separation: UI watches providers, providers own all logic

**How it works:**

| Provider | Type | Purpose |
|---|---|---|
| `moodProvider` | `StateNotifierProvider` | Holds the list of `MoodEntry` objects, loads/saves via SharedPreferences |
| `selectedEntryProvider` | `StateProvider<int?>` | Index of the tapped timeline card (null = nothing selected) |

---

## 💾 Storage — SharedPreferences

`shared_preferences` uses **localStorage** on Flutter Web automatically.
No extra setup needed. Entries survive page refresh.

Each `MoodEntry` is JSON-encoded to a `String` and stored as a `List<String>`.

---

## 🎨 CustomPainter — How the Faces Work

Every face is drawn in `lib/painters/mood_face_painter.dart` using only:

| Method | Used for |
|---|---|
| `canvas.drawCircle` | Head, eyes, cheeks |
| `canvas.drawArc` | Smile, frown, eyebrows (excited) |
| `canvas.drawLine` | Flat mouth (neutral), straight eyebrows |
| `canvas.drawOval` | Narrowed eyes (angry) |
| `canvas.drawPath` | Teardrop (sad), vein (angry), open mouth (excited) |

**Smile vs Frown arc logic:**
```
Smile  → drawArc starting at 0° sweeping clockwise through 90° (DOWN) = bottom arc
Frown  → drawArc starting at 180°+ sweeping clockwise through 270° (UP) = top arc
```

---

## 🚀 Setup & Run

```bash
# 1. Create a new Flutter project
flutter create mood_tracker
cd mood_tracker

# 2. Replace the generated files with the provided source files

# 3. Install dependencies
flutter pub get

# 4. Run on Chrome
flutter run -d chrome

# 5. Build for production
flutter build web
```

---

## ☁️ Deploy to Vercel

```bash
# Build
flutter build web

# Install Vercel CLI
npm install -g vercel

# Deploy the build/web folder
cd build/web
vercel --prod
```

## ☁️ Deploy to Firebase Hosting

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login & init
firebase login
firebase init hosting
# Set public directory to: build/web
# Configure as single-page app: Yes

# Build & deploy
flutter build web
firebase deploy
```

---

## ✅ Features Checklist

- [x] 5 mood types: Happy, Neutral, Sad, Excited, Angry
- [x] All faces drawn with `CustomPainter` — zero images or emoji
- [x] Tap to log mood with glow animation
- [x] Last 7 entries in horizontal scrollable timeline
- [x] Timeline cards show: drawn face + date + time + mood label + colour accent bar
- [x] Tap any card → bounce animation + detail panel slides in
- [x] State managed with **Riverpod** (`StateNotifier` + `StateProvider`)
- [x] Entries persisted with **SharedPreferences** (web localStorage)
- [x] Responsive layout (max-width 620 px, works on any screen)
