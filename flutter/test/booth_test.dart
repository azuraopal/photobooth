import 'dart:typed_data';

import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:photobooth/booth.dart';
import 'package:photobooth/main.dart';
import 'package:photobooth/export.dart';

void main() {
  testWidgets('Fractional strip preview exports exactly 600 by 1800', (
    tester,
  ) async {
    final key = GlobalKey();
    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: SizedBox(
            width: 82.6666666667,
            child: RepaintBoundary(
              key: key,
              child: PhotoSheet(
                layout: layouts[4],
                frame: frames[0],
                filter: filters[0],
                photos: const [],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final boundary =
        key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final bytes = await tester.runAsync(
      () => captureSheetPng(boundary, aspect: layouts[4].aspect),
    );
    final header = ByteData.sublistView(bytes!);
    expect(header.getUint32(16), 600);
    expect(header.getUint32(20), 1800);
  });
  test('Every layout has complete rows and a positive printable ratio', () {
    expect(layouts.length, 12);
    for (final layout in layouts) {
      expect(layout.rows * layout.columns, layout.count);
      expect(layout.aspect, greaterThan(0));
      expect([2, 3, 4, 6], contains(layout.count));
    }
    expect(layouts[4].aspect, 600 / 1800);
  });

  testWidgets('All layouts render at thumbnail and full preview sizes', (
    tester,
  ) async {
    for (final width in [50.0, 280.0]) {
      for (final layout in layouts) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: SizedBox(
                  width: width,
                  height: 350,
                  child: PhotoSheet(
                    layout: layout,
                    frame: frames[3],
                    filter: filters[2],
                    photos: const [],
                  ),
                ),
              ),
            ),
          ),
        );
        expect(
          tester.takeException(),
          isNull,
          reason: '${layout.name} at $width',
        );
        expect(
          find.byIcon(Icons.face_retouching_natural),
          findsNWidgets(layout.count),
        );
      }
    }
  });

  testWidgets(
    'Studio starts without requesting camera and changes editing panels',
    (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const MainApp());
      expect(find.text('Photobooth'), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.text('Mulai sesi foto').hitTestable(), findsOneWidget);
      await tester.ensureVisible(find.text('Filter'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Filter'));
      await tester.pumpAndSettle();
      expect(find.text('Monokrom'), findsOneWidget);
      await tester.ensureVisible(find.text('Monokrom'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Monokrom'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.ensureVisible(find.text('Bingkai'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Bingkai'));
      await tester.pumpAndSettle();
      expect(find.text('Spooky Social'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Small iPhone with large text keeps capture reachable', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(1.5)),
        child: const MainApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Mulai sesi foto').hitTestable(), findsOneWidget);
    await tester.ensureVisible(find.text('Filter'));
    await tester.tap(find.text('Filter'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Catatan & timer 3s'));
    await tester.tap(find.text('Catatan & timer 3s'));
    await tester.pumpAndSettle();
    expect(find.text('Sentuhan terakhir'), findsOneWidget);
    await tester.tap(find.text('5 detik'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Selesai'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Selesai'));
    await tester.pumpAndSettle();
    expect(find.text('Catatan & timer 5s'), findsOneWidget);
    expect(find.text('Mulai sesi foto').hitTestable(), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
