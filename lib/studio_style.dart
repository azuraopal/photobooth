import 'package:material_ui/material_ui.dart';

abstract final class StudioColors {
  static const paper = Color(0xFFFAF9FC);
  static const ink = Color(0xFF302436);
  static const muted = Color(0xFF6D6473);
  static const accent = Color(0xFF9D294E);
  static const table = Color(0xFFDCE7ED);
  static const line = Color(0xFFE2DEE6);
}

class StudioBackdrop extends CustomPainter {
  const StudioBackdrop();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x1880929D)
      ..strokeWidth = .6;
    for (double x = 0; x < size.width; x += 24) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 24) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(StudioBackdrop oldDelegate) => false;
}

class FilterSample extends StatelessWidget {
  const FilterSample({super.key});

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Contoh warna filter',
    child: const CustomPaint(painter: _ColorStudy(), child: SizedBox.expand()),
  );
}

class _ColorStudy extends CustomPainter {
  const _ColorStudy();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(const Color(0xFF87ACC1), BlendMode.srcOver);
    canvas.drawCircle(
      Offset(size.width * .73, size.height * .24),
      size.width * .17,
      Paint()..color = const Color(0xFFF3D588),
    );
    canvas.drawOval(
      Rect.fromLTWH(
        -size.width * .15,
        size.height * .52,
        size.width * 1.4,
        size.height,
      ),
      Paint()..color = const Color(0xFF44645C),
    );
    final vase = Path()
      ..moveTo(size.width * .28, size.height * .42)
      ..lineTo(size.width * .62, size.height * .42)
      ..lineTo(size.width * .69, size.height * .85)
      ..quadraticBezierTo(
        size.width * .45,
        size.height * .98,
        size.width * .22,
        size.height * .85,
      )
      ..close();
    canvas.drawPath(vase, Paint()..color = const Color(0xFFD48779));
  }

  @override
  bool shouldRepaint(_ColorStudy oldDelegate) => false;
}
