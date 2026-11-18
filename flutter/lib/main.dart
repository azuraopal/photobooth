import 'package:material_ui/material_ui.dart';

import 'studio.dart';
import 'studio_style.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photobooth',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        splashFactory: InkRipple.splashFactory,
        scaffoldBackgroundColor: StudioColors.paper,
        appBarTheme: const AppBarTheme(
          backgroundColor: StudioColors.paper,
          foregroundColor: StudioColors.ink,
          scrolledUnderElevation: 0,
          centerTitle: false,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: StudioColors.accent,
          primary: StudioColors.accent,
          onSurface: StudioColors.ink,
          surface: StudioColors.paper,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: StudioColors.accent,
            foregroundColor: Colors.white,
            minimumSize: const Size(48, 52),
          ),
        ),
      ),
      home: const StudioScreen(),
    );
  }
}
