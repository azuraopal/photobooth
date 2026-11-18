import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_ui/material_ui.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'booth.dart';
import 'capture.dart';
import 'export.dart';
import 'studio_style.dart';

class StudioScreen extends StatefulWidget {
  const StudioScreen({super.key});
  @override
  State<StudioScreen> createState() => _StudioScreenState();
}

class _StudioScreenState extends State<StudioScreen> {
  int _layout = 4;
  int _frame = 0;
  int _filter = 0;
  int _panel = 0;
  int _timer = 3;
  bool _working = false;
  final _sheetKey = GlobalKey();
  final _caption = TextEditingController(text: 'Momen kecil, cerita besar.');
  List<Uint8List> _photos = [];
  BoothLayout get layout => layouts[_layout];

  @override
  void dispose() {
    _caption.dispose();
    super.dispose();
  }

  void _message(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Future<void> _shoot({int? replace}) async {
    final result = await Navigator.push<List<Uint8List>>(
      context,
      MaterialPageRoute(
        builder: (_) => CaptureScreen(
          count: replace == null ? layout.count : 1,
          filter: filters[_filter],
          seconds: _timer,
        ),
      ),
    );
    if (!mounted || result == null || result.isEmpty) return;
    setState(() {
      if (replace != null && replace < _photos.length) {
        _photos[replace] = result.first;
      } else {
        _photos = result;
      }
    });
  }

  Future<void> _import() async {
    try {
      final files = await ImagePicker().pickMultiImage(
        maxWidth: 2400,
        maxHeight: 2400,
        imageQuality: 92,
      );
      if (files.isEmpty) return;
      final photos = await Future.wait(
        files.take(layout.count).map((file) => file.readAsBytes()),
      );
      if (!mounted) return;
      setState(() => _photos = photos);
      if (photos.length < layout.count) {
        _message('Pilih ${layout.count} foto untuk mengisi semua slot.');
      }
    } catch (_) {
      _message('Foto belum bisa dibuka. Periksa izin galeri lalu coba lagi.');
    }
  }

  Future<void> _export({required bool share}) async {
    if (_working || _photos.length < layout.count) return;
    setState(() => _working = true);
    try {
      await WidgetsBinding.instance.endOfFrame;
      final boundary =
          _sheetKey.currentContext!.findRenderObject()!
              as RenderRepaintBoundary;
      final bytes = await captureSheetPng(boundary, aspect: layout.aspect);
      final name = 'photobooth-${DateTime.now().millisecondsSinceEpoch}.png';
      if (share || kIsWeb) {
        if (!mounted) return;
        final box = context.findRenderObject()! as RenderBox;
        await SharePlus.instance.share(
          ShareParams(
            files: [XFile.fromData(bytes, mimeType: 'image/png', name: name)],
            fileNameOverrides: [name],
            sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
          ),
        );
      } else {
        final directory = await getApplicationDocumentsDirectory();
        final sessions = await Directory('${directory.path}/sessions')
            .create(recursive: true);
        await File('${sessions.path}/$name').writeAsBytes(bytes, flush: true);
        _message(
          'Tersimpan di Koleksi. Gunakan Bagikan untuk menyimpan ke galeri/Files.',
        );
      }
    } catch (_) {
      _message('Ekspor belum berhasil. Foto tetap ada; coba lagi.');
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  Future<void> _collection() async {
    if (kIsWeb) {
      _message('Di web, gunakan Bagikan untuk mengunduh hasil sesi.');
      return;
    }
    try {
      final directory = await getApplicationDocumentsDirectory();
      final sessions = Directory('${directory.path}/sessions');
      final files = await sessions.exists()
          ? await sessions
                .list()
                .where((file) => file.path.endsWith('.png'))
                .toList()
          : <FileSystemEntity>[];
      files.sort((first, second) => second.path.compareTo(first.path));
      if (!mounted) return;
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (context) => SizedBox(
          height: MediaQuery.sizeOf(context).height * .75,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Koleksi di perangkat ini',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                ),
              ),
              if (files.isEmpty)
                const Expanded(
                  child: Center(
                    child: Text('Sesi pertamamu akan muncul di sini.'),
                  ),
                )
              else
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(20),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: .55,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 20,
                        ),
                    itemCount: files.length,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () async {
                        final box = context.findRenderObject()! as RenderBox;
                        try {
                          await SharePlus.instance.share(
                            ShareParams(
                              files: [XFile(files[index].path)],
                              sharePositionOrigin:
                                  box.localToGlobal(Offset.zero) & box.size,
                            ),
                          );
                        } catch (_) {
                          _message('Tidak bisa membuka menu berbagi.');
                        }
                      },
                      child: Image.file(
                        File(files[index].path),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    } catch (_) {
      _message('Koleksi belum bisa dibuka. Coba lagi.');
    }
  }

  Future<void> _reset() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mulai sesi baru?'),
        content: const Text(
          'Foto sesi saat ini akan dilepas. Simpan hasilnya terlebih dahulu jika ingin menyimpannya.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Kembali'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sesi baru'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) setState(() => _photos = []);
  }

  Widget _choice({
    required bool selected,
    required VoidCallback onTap,
    required Widget child,
  }) => Material(
    color: selected ? const Color(0xFFF8EAF0) : Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(
        color: selected ? StudioColors.accent : StudioColors.line,
        width: 2,
      ),
    ),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: _working ? null : onTap,
      child: Padding(padding: const EdgeInsets.all(12), child: child),
    ),
  );

  Future<void> _settings() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => StatefulBuilder(
        builder: (context, updateSheet) => SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            24,
            8,
            24,
            MediaQuery.viewInsetsOf(context).bottom + 28,
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sentuhan terakhir',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _caption,
                  maxLength: 50,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    labelText: 'Catatan di bingkai',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                const Text('Jeda antar foto'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  children: [3, 5, 10]
                      .map(
                        (seconds) => ChoiceChip(
                          label: Text('$seconds detik'),
                          selected: _timer == seconds,
                          onSelected: (_) {
                            setState(() => _timer = seconds);
                            updateSheet(() {});
                          },
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Selesai'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _choices() {
    final count = _panel == 0
        ? layouts.length
        : _panel == 1
        ? frames.length
        : filters.length;
    final selected = [_layout, _frame, _filter][_panel];
    return SizedBox(
      height: 142 + (MediaQuery.textScalerOf(context).scale(12) - 12) * 3,
      child: SingleChildScrollView(
        key: ValueKey('choices-$_panel'),
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: List.generate(count, (position) {
            const layoutOrder = [4, 8, 0, 1, 2, 3, 5, 6, 7, 9, 10, 11];
            final index = _panel == 0 ? layoutOrder[position] : position;
            void select() => setState(() {
              if (_panel == 0) _layout = index;
              if (_panel == 1) _frame = index;
              if (_panel == 2) _filter = index;
            });
            final label = _panel == 0
                ? layouts[index].name
                : _panel == 1
                ? frames[index].name
                : filters[index].name;
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: SizedBox(
                width: 112,
                child: Semantics(
                  button: true,
                  selected: selected == index,
                  label: label,
                  excludeSemantics: true,
                  onTap: _working ? null : select,
                  child: _choice(
                    selected: selected == index,
                    onTap: select,
                    child: Column(
                      children: [
                        Expanded(
                          child: Center(
                            child: _panel == 2
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: ColorFiltered(
                                      colorFilter: ColorFilter.matrix(
                                        filters[index].matrix,
                                      ),
                                      child: _photos.isEmpty
                                          ? const FilterSample()
                                          : Image.memory(
                                              _photos.first,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: double.infinity,
                                              cacheWidth: 240,
                                            ),
                                    ),
                                  )
                                : PhotoSheet(
                                    layout: _panel == 0
                                        ? layouts[index]
                                        : layout,
                                    frame: frames[_panel == 1 ? index : _frame],
                                    filter: filters[_filter],
                                    photos: _panel == 0 ? const [] : _photos,
                                    caption: '',
                                    decodeWidth: 240,
                                  ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          label,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 11,
                            height: 1.15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (_panel == 0)
                          Text(
                            '${layouts[index].count} foto',
                            style: const TextStyle(
                              fontSize: 10,
                              color: StudioColors.muted,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ready = _photos.length >= layout.count;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: const Text(
          'Photobooth',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.w800,
            letterSpacing: -1,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Koleksi',
            onPressed: _collection,
            icon: const Icon(Icons.photo_library_outlined),
          ),
          const SizedBox(width: 10),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
          decoration: const BoxDecoration(
            color: StudioColors.paper,
            border: Border(top: BorderSide(color: StudioColors.line)),
          ),
          child: Row(
            children: [
              IconButton.outlined(
                tooltip: 'Pilih foto dari galeri',
                onPressed: _working ? null : _import,
                style: IconButton.styleFrom(minimumSize: const Size(52, 52)),
                icon: const Icon(Icons.add_photo_alternate_outlined),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: _working
                      ? null
                      : ready
                      ? () => _export(share: false)
                      : () => _shoot(),
                  icon: Icon(
                    ready ? Icons.bookmark_border : Icons.camera_alt_outlined,
                  ),
                  label: Text(
                    _working
                        ? 'Memproses…'
                        : ready
                        ? 'Simpan sesi'
                        : 'Mulai sesi foto',
                  ),
                ),
              ),
              if (ready) ...[
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  tooltip: 'Bagikan PNG',
                  onPressed: _working ? null : () => _export(share: true),
                  icon: const Icon(Icons.ios_share),
                ),
              ],
            ],
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: SingleChildScrollView(
              key: const ValueKey('studio-scroll'),
              padding: const EdgeInsets.only(top: 8, bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ready
                                    ? 'Simpan ceritamu.'
                                    : 'Satu strip, banyak cerita.',
                                style: const TextStyle(
                                  fontSize: 24,
                                  height: 1.12,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -.8,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                ready
                                    ? 'Ketuk foto untuk mengambil ulang.'
                                    : 'Pilih desain, lalu isi dengan momenmu.',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: StudioColors.muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: ColoredBox(
                        color: StudioColors.table,
                        child: Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.sizeOf(context).height < 700
                                  ? 230
                                  : 250,
                              child: CustomPaint(
                                painter: const StudioBackdrop(),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      30,
                                      20,
                                      30,
                                      14,
                                    ),
                                    child: Transform.rotate(
                                      angle: -.045,
                                      child: DecoratedBox(
                                        decoration: const BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color(0x26322436),
                                              blurRadius: 14,
                                              offset: Offset(4, 8),
                                            ),
                                          ],
                                        ),
                                        child: RepaintBoundary(
                                          key: _sheetKey,
                                          child: PhotoSheet(
                                            layout: layout,
                                            frame: frames[_frame],
                                            filter: filters[_filter],
                                            photos: _photos,
                                            caption: _caption.text,
                                            onPhotoTap: _working
                                                ? null
                                                : (index) {
                                                    if (index <
                                                        _photos.length) {
                                                      _shoot(replace: index);
                                                    }
                                                  },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      layout.name,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    '${_photos.length.clamp(0, layout.count)}/${layout.count} foto',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: StudioColors.muted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: List.generate(
                        3,
                        (index) => Expanded(
                          child: Semantics(
                            selected: _panel == index,
                            child: TextButton(
                              onPressed: _working
                                  ? null
                                  : () => setState(() => _panel = index),
                              style: TextButton.styleFrom(
                                foregroundColor: _panel == index
                                    ? StudioColors.accent
                                    : StudioColors.muted,
                                backgroundColor: _panel == index
                                    ? const Color(0xFFF3E5ED)
                                    : Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                ['Layout', 'Bingkai', 'Filter'][index],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _choices(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    child: Wrap(
                      spacing: 8,
                      alignment: WrapAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          onPressed: _working ? null : _settings,
                          icon: const Icon(Icons.tune, size: 18),
                          label: Text('Catatan & timer ${_timer}s'),
                        ),
                        if (_photos.isNotEmpty)
                          TextButton(
                            onPressed: _working ? null : _reset,
                            child: const Text('Sesi baru'),
                          ),
                      ],
                    ),
                  ),
                  const Center(
                    child: Text(
                      'Momenmu tetap di perangkatmu.',
                      style: TextStyle(fontSize: 11, color: StudioColors.muted),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
