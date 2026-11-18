# Photobooth

Flutter photobooth for Android and iOS. Open this `flutter` folder in Orca, select a Codex chat, and work from prompts. Run the commands below from this folder.

## Run

```sh
flutter pub get
flutter devices
flutter run -d <device-id>
```

Android SDK and device setup are managed through Android Studio. Xcode provides the iOS simulator and build tools. Both runtimes can be attached using Orca's Emulator pane.

## Current features

Camera sessions, timed captures with pose prompts, gallery import, 12 layouts, six frame palettes, seven filters, targeted retakes, captions, local collections and PNG sharing. The classic strip is exported at 600 x 1800 pixels. Saved sessions live in the app's documents directory; use the share sheet to save to Photos or Files.

No account or backend is required. Photos are not automatically uploaded. Camera quality and gallery integration need physical-device testing. AR effects, generative backgrounds and motion clips are planned, not implemented.

## Checks

```sh
dart format lib test
flutter analyze
flutter test
flutter build apk --debug
flutter build ios --simulator --debug
```

See `docs/PRODUCT.md` for product scope and `.agents/skills/photobooth-flutter/SKILL.md` for project guidance.
