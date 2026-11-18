import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:material_ui/material_ui.dart';

import 'booth.dart';

class CaptureScreen extends StatefulWidget {
  const CaptureScreen({
    super.key,
    required this.count,
    required this.filter,
    required this.seconds,
  });
  final int count;
  final BoothFilter filter;
  final int seconds;
  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen>
    with WidgetsBindingObserver {
  CameraController? _camera;
  List<CameraDescription> _cameras = [];
  final List<Uint8List> _photos = [];
  String? _error;
  bool _busy = false;
  int _countdown = 0;
  int _generation = 0;
  int _cameraIndex = 0;
  static const _poses = [
    'Dekat sedikit. Senyum bebas.',
    'Lihat temanmu, jangan kamera.',
    'Tunjukkan pose andalanmu.',
    'Satu ekspresi paling spontan.',
    'Bikin hati dengan tangan.',
    'Terakhir: rayakan momennya!',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initialize();
  }

  Future<void> _initialize() async {
    final generation = ++_generation;
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        throw StateError(
          'Kamera tidak tersedia. Gunakan impor foto di halaman studio.',
        );
      }
      if (_camera == null) {
        final front = _cameras.indexWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
        );
        _cameraIndex = front < 0 ? 0 : front;
      }
      final previous = _camera;
      _camera = null;
      await previous?.dispose();
      final camera = CameraController(
        _cameras[_cameraIndex],
        ResolutionPreset.high,
        enableAudio: false,
      );
      await camera.initialize();
      if (!mounted || generation != _generation) {
        await camera.dispose();
        return;
      }
      setState(() {
        _camera = camera;
        _error = null;
      });
    } catch (error) {
      if (mounted && generation == _generation) {
        setState(
          () => _error = error is CameraException
              ? 'Kamera belum bisa diakses. Periksa izin kamera di Pengaturan, lalu coba lagi.'
              : error.toString(),
        );
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      _generation++;
      final camera = _camera;
      _camera = null;
      camera?.dispose();
      if (mounted) {
        setState(() {
          _busy = false;
          _countdown = 0;
        });
      }
    } else if (state == AppLifecycleState.resumed) {
      _initialize();
    }
  }

  Future<void> _capture() async {
    if (_busy || _camera == null) return;
    final generation = _generation;
    setState(() => _busy = true);
    try {
      while (_photos.length < widget.count) {
        for (var remaining = widget.seconds; remaining > 0; remaining--) {
          if (!mounted || generation != _generation) return;
          setState(() => _countdown = remaining);
          await Future<void>.delayed(const Duration(seconds: 1));
        }
        if (!mounted || generation != _generation) return;
        setState(() => _countdown = 0);
        final photo = await _camera!.takePicture();
        final bytes = await photo.readAsBytes();
        if (!mounted || generation != _generation) return;
        setState(() => _photos.add(bytes));
      }
      if (mounted) Navigator.pop(context, _photos);
    } catch (_) {
      if (mounted) {
        setState(() {
          _busy = false;
          _error = 'Foto belum berhasil diambil. Coba lagi; foto sebelumnya tetap tersimpan selama sesi ini.';
        });
      }
    }
  }

  @override
  void dispose() {
    _generation++;
    WidgetsBinding.instance.removeObserver(this);
    _camera?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF191C1A),
    appBar: AppBar(
      backgroundColor: const Color(0xFF191C1A),
      foregroundColor: Colors.white,
      title: Text(
        'Foto ${(_photos.length + 1).clamp(1, widget.count)} dari ${widget.count}',
      ),
    ),
    body: SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (_camera?.value.isInitialized ?? false)
                  Center(
                    child: ColorFiltered(
                      colorFilter: ColorFilter.matrix(widget.filter.matrix),
                      child: CameraPreview(_camera!),
                    ),
                  )
                else if (_error == null)
                  const CircularProgressIndicator(),
                if (_countdown > 0)
                  Text(
                    '$_countdown',
                    style: const TextStyle(
                      fontSize: 110,
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      shadows: [Shadow(blurRadius: 20)],
                    ),
                  ),
                if (_error != null)
                  Container(
                    padding: const EdgeInsets.all(24),
                    margin: const EdgeInsets.all(24),
                    color: const Color(0xEE252925),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white),
                        ),
                        TextButton(
                          onPressed: _initialize,
                          child: const Text('Coba lagi'),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  _poses[_photos.length % _poses.length],
                  style: const TextStyle(color: Colors.white, fontSize: 17),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  'Panduan pose • Timer ${widget.seconds} detik',
                  style: const TextStyle(color: Colors.white60),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      '${_photos.length}/${widget.count}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    Semantics(
                      label: 'Mulai pemotretan',
                      button: true,
                      child: IconButton.filled(
                        onPressed: _busy || _camera == null ? null : _capture,
                        iconSize: 58,
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFFF07751),
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.camera),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Ganti kamera',
                      onPressed: _busy || _cameras.length < 2
                          ? null
                          : () {
                              _cameraIndex =
                                  (_cameraIndex + 1) % _cameras.length;
                              _initialize();
                            },
                      icon: const Icon(
                        Icons.flip_camera_ios_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
