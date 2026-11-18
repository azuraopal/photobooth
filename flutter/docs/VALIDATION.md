# Validation

## Automated checks

- `flutter analyze`: exit 0, no issues found.
- `flutter test`: exit 0, five tests passed.
- `flutter build ios --simulator --debug`: exit 0, simulator app built.
- Tests cover the twelve layouts, thumbnail rendering, editing-panel changes,
  capture availability on a narrow screen with enlarged text, timer settings,
  and exact 600 x 1800 PNG output from a fractional-size strip preview.

## iPhone simulator checks

Tested on iPhone 18 Pro, iOS 27.0, with the simulator attached to Orca.

- Studio screen, safe-area toolbar and horizontally scrollable choices inspected.
- Four synthetic PNG images imported through the native iOS photo picker.
- Monochrome filter selection exercised.
- A saved classic-strip PNG was read back and visually inspected: exactly
  600 x 1800 pixels, with all four fixture images and the caption present.
- Native iOS sharing sheet opened with a PNG attachment. Nothing was sent.

## Limits

No physical iPhone was connected during this check. Real camera capture,
physical-device performance and signing for distribution remain unverified.
The latest checkout was built for iOS; Android was built in the preceding
development iteration, before this UI refinement. AR and video are not implemented.
