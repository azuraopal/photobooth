# Photobooth

The Flutter app for Android and iOS is in [`flutter/`](flutter/README.md).
It includes timed camera sessions, gallery import, twelve photo layouts, six frame
palettes, seven reversible filters, captions, local collections and PNG sharing.

```sh
cd flutter
flutter pub get
flutter devices
flutter run -d <device-id>
```

See [`flutter/docs/DESIGN.md`](flutter/docs/DESIGN.md) for the UI system and
[`flutter/docs/PRODUCT.md`](flutter/docs/PRODUCT.md) for scope and limitations.

The original Swift prototype remains at the repository root. The Flutter app is
independent and does not require the prototype's Python server.
