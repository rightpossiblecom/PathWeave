# PathWeave

**PathWeave** is an offline single-stroke spatial logic puzzle game built with Flutter (`com.pathweave.app`). Draw one unbroken ribbon from the start node across every open tile on the grid while navigating around stone blocks and hitting numbered step anchors on exact move counts.

## Highlights

- **40 Verified Campaign Puzzles** across 4 chapters (*Breeze*, *Weave*, *Labyrinth*, *Mastery*) from 4×4 warmups to 7×6 boards.
- **Daily Weave Mode** generating a deterministic 6×5 puzzle every day with local streak tracking.
- **Tactile Board Controls** with continuous pan-drag weaving, tap-to-step, drag-back unwinding, undo, reset, and prefix-restoring smart hints.
- **Material 3 Light & Dark Themes**, optional step-number overlay, and haptic feedback.
- **100% Offline & Privacy-First**: No login, no signup, no analytics, and local-only `Hive` persistence.

## Project Structure

```text
lib/
├── core/
│   ├── constants/       # App metadata & 40 verified Hamiltonian levels + Daily generator
│   ├── services/        # Hive simple-box local storage
│   └── theme/           # Material 3 Light & Dark ColorScheme themes
├── features/
│   ├── home/            # Campaign chapters, level selector, daily card
│   ├── game/            # CustomPainter interactive weave board & ViewModel
│   ├── stats/           # Mastery, star totals, and chapter progress
│   ├── settings/        # Theme mode, haptics, step numbers, clear data, feedback
│   └── about/           # App info, Privacy Policy, Terms of Service, OSS licenses
└── main.dart
```

## Release & Signing Documentation

All Play Store release assets, signing credentials (`pathweave-release.jks` + `key.properties`), certificate fingerprints, store listing copy, and upload/transfer instructions are documented in [`docs/release/README.md`](docs/release/README.md).

## Development & Build

```bash
flutter pub get
flutter analyze
flutter test
flutter build appbundle --release
```
