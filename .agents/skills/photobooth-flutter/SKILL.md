---
name: photobooth-flutter
description: Build and verify Photobooth's Flutter photobooth, including camera sessions, photo layouts, frames, filters, PNG exports, and mobile UX. Use when editing this project's Dart code or camera/platform integration.
---

# Photobooth development

Read this guide when working in this project. Use the installed Flutter stable SDK and lockfile. Current generated project uses material_ui for Material components.

- Keep capture originals untouched; filters and frames must be reversible.
- Use the same PhotoSheet renderer for preview and PNG export. Classic strip exports at 600 x 1800 pixels.
- Preserve 2, 3, 4, and 6 photo layouts, sufficient touch targets, readable contrast, and narrow screen support.
- Camera initialization must be explicit after starting a session, handle denied access, pause/dispose on lifecycle changes, and stop countdowns after navigation.
- Photos stay on device unless the user explicitly shares. Do not add automatic uploads, face recognition, credentials, or cloud dependencies.
- Artwork must be original. User references describe functionality, not permission to copy third-party assets.
- Keep AR, generative backgrounds, and video features out of enabled controls until functional and tested.
- Run dart format, flutter analyze, and flutter test. Verify an emulator build and inspect mobile rendering; report physical-camera testing separately.
- Use Orca's emulator skill for its embedded emulator pane. Do not create commits, pushes, or pull requests without authorization.
