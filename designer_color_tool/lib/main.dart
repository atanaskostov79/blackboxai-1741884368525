import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/color_picker_screen.dart';
import 'screens/image_color_extraction_screen.dart';
import 'screens/palette_screen.dart';
import 'screens/font_suggestion_screen.dart';
import 'models/app_state.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const DesignerColorApp(),
    ),
  );
}

class DesignerColorApp extends StatelessWidget {
  const DesignerColorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Designer Color Tool',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/color-picker': (context) => const ColorPickerScreen(),
        '/image-extraction': (context) => const ImageColorExtractionScreen(),
        '/palette': (context) => const PaletteScreen(),
        '/font-suggestion': (context) => const FontSuggestionScreen(),
      },
    );
  }
}
