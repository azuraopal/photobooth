import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';

Future<Uint8List> captureSheetPng(
  RenderRepaintBoundary boundary, {
  required double aspect,
}) async {
  const width = 600;
  final height = (width / aspect).round();
  final snapshot = await boundary.toImage(
    pixelRatio: width / boundary.size.width,
  );
  final recorder = ui.PictureRecorder();
  final canvas = ui.Canvas(recorder);
  canvas.drawImageRect(
    snapshot,
    ui.Rect.fromLTWH(
      0,
      0,
      snapshot.width.toDouble(),
      snapshot.height.toDouble(),
    ),
    ui.Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
    ui.Paint()..filterQuality = ui.FilterQuality.high,
  );
  final picture = recorder.endRecording();
  try {
    final output = await picture.toImage(width, height);
    try {
      final data = await output.toByteData(format: ui.ImageByteFormat.png);
      if (data == null) throw StateError('PNG kosong');
      return data.buffer.asUint8List();
    } finally {
      output.dispose();
    }
  } finally {
    picture.dispose();
    snapshot.dispose();
  }
}
