import 'dart:typed_data';

import 'package:material_ui/material_ui.dart';

class BoothLayout {
  const BoothLayout(this.name, this.count, this.columns, this.aspect);
  final String name;
  final int count;
  final int columns;
  final double aspect;
  int get rows => (count / columns).ceil();
}

const layouts = [
  BoothLayout('Duo lebar', 2, 2, 1.5),
  BoothLayout('Duo strip', 2, 1, .5),
  BoothLayout('Trio klasik', 3, 1, .4),
  BoothLayout('Trio editorial', 3, 1, .5),
  BoothLayout('Strip klasik', 4, 1, 1 / 3),
  BoothLayout('Strip rapat', 4, 1, .38),
  BoothLayout('Film panjang', 4, 1, .28),
  BoothLayout('Mini strip', 4, 1, .45),
  BoothLayout('Kotak empat', 4, 2, 1),
  BoothLayout('Portrait grid', 4, 2, .75),
  BoothLayout('Wide grid', 4, 2, 1.25),
  BoothLayout('Enam cerita', 6, 2, 2 / 3),
];

class BoothFrame {
  const BoothFrame(this.name, this.paper, this.ink, this.mark);
  final String name;
  final Color paper;
  final Color ink;
  final String mark;
}

const frames = [
  BoothFrame('Kertas', Color(0xFFFFFDF8), Color(0xFF202321), 'GOOD TOGETHER'),
  BoothFrame(
    'After Hours',
    Color(0xFF202321),
    Color(0xFFEBB36E),
    'AFTER HOURS',
  ),
  BoothFrame(
    'Cherry Club',
    Color(0xFF922F3E),
    Color(0xFFFFE3CE),
    'CHERRY CLUB',
  ),
  BoothFrame(
    'Spooky Social',
    Color(0xFF291F3A),
    Color(0xFFFFBB71),
    'BOO! CREW',
  ),
  BoothFrame(
    'Butter Yellow',
    Color(0xFFF5DF8D),
    Color(0xFF3A4A37),
    'A LITTLE SUNSHINE',
  ),
  BoothFrame('Blush Notes', Color(0xFFF1CDD7), Color(0xFF6B3347), 'YOU + ME'),
];

class BoothFilter {
  const BoothFilter(this.name, this.matrix);
  final String name;
  final List<double> matrix;
}

const filters = [
  BoothFilter('Normal', [
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
  ]),
  BoothFilter('Monokrom', [
    .213,
    .715,
    .072,
    0,
    0,
    .213,
    .715,
    .072,
    0,
    0,
    .213,
    .715,
    .072,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
  ]),
  BoothFilter('Warm film', [
    1.08,
    0,
    0,
    0,
    8,
    0,
    1,
    0,
    0,
    3,
    0,
    0,
    .85,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
  ]),
  BoothFilter('Soft glow', [
    .9,
    0,
    0,
    0,
    20,
    0,
    .9,
    0,
    0,
    16,
    0,
    0,
    .9,
    0,
    16,
    0,
    0,
    0,
    1,
    0,
  ]),
  BoothFilter('Midnight', [
    .75,
    0,
    0,
    0,
    0,
    0,
    .85,
    0,
    0,
    0,
    0,
    0,
    1.05,
    0,
    8,
    0,
    0,
    0,
    1,
    0,
  ]),
  BoothFilter('Sepia', [
    .393,
    .769,
    .189,
    0,
    0,
    .349,
    .686,
    .168,
    0,
    0,
    .272,
    .534,
    .131,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
  ]),
  BoothFilter('Horror', [
    .35,
    0,
    0,
    0,
    0,
    0,
    1.05,
    0,
    0,
    10,
    0,
    0,
    .45,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
  ]),
];

class PhotoSheet extends StatelessWidget {
  const PhotoSheet({
    super.key,
    required this.layout,
    required this.frame,
    required this.filter,
    required this.photos,
    this.caption = 'Momen kecil, cerita besar.',
    this.onPhotoTap,
    this.decodeWidth,
  });
  final BoothLayout layout;
  final BoothFrame frame;
  final BoothFilter filter;
  final List<Uint8List> photos;
  final String caption;
  final ValueChanged<int>? onPhotoTap;
  final int? decodeWidth;

  @override
  Widget build(BuildContext context) => AspectRatio(
    aspectRatio: layout.aspect,
    child: LayoutBuilder(
      builder: (context, constraints) {
        final padding = constraints.maxWidth * .055;
        final gap = constraints.maxWidth * .025;
        return ColoredBox(
          color: frame.paper,
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              children: [
                SizedBox(
                  height: constraints.maxHeight * .035,
                  child: FittedBox(
                    child: Text(
                      frame.mark,
                      style: TextStyle(
                        color: frame.ink,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: gap),
                Expanded(
                  child: Column(
                    children: List.generate(
                      layout.rows,
                      (row) => Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: gap),
                          child: Row(
                            children: List.generate(layout.columns, (column) {
                              final index = row * layout.columns + column;
                              return Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    right: column < layout.columns - 1
                                        ? gap
                                        : 0,
                                  ),
                                  child: GestureDetector(
                                    onTap: onPhotoTap == null
                                        ? null
                                        : () => onPhotoTap!(index),
                                    child: ClipRect(
                                      child: index < photos.length
                                          ? ColorFiltered(
                                              colorFilter: ColorFilter.matrix(
                                                filter.matrix,
                                              ),
                                              child: Image.memory(
                                                photos[index],
                                                cacheWidth: decodeWidth,
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                height: double.infinity,
                                              ),
                                            )
                                          : ColoredBox(
                                              color: frame.ink.withValues(
                                                alpha: .09,
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons.face_retouching_natural,
                                                  color: frame.ink.withValues(
                                                    alpha: .35,
                                                  ),
                                                  size:
                                                      constraints.maxWidth *
                                                      .14,
                                                ),
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: constraints.maxHeight * .035,
                  child: FittedBox(
                    child: Text(
                      caption,
                      style: TextStyle(
                        color: frame.ink,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: gap / 2),
                SizedBox(
                  height: constraints.maxHeight * .025,
                  child: FittedBox(
                    child: Text(
                      'PHOTOBOOTH / MADE OF MOMENTS',
                      style: TextStyle(
                        color: frame.ink,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}
