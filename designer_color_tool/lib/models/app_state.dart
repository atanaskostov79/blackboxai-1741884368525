import 'package:flutter/material.dart';
import 'color_scheme_model.dart';
import 'font_model.dart';

class AppState extends ChangeNotifier {
  // Selected color
  Color _selectedColor = Colors.blue;
  Color get selectedColor => _selectedColor;

  // Current color scheme
  ColorSchemeModel? _currentScheme;
  ColorSchemeModel? get currentScheme => _currentScheme;

  // List of generated palettes
  List<ColorSchemeModel> _savedPalettes = [];
  List<ColorSchemeModel> get savedPalettes => _savedPalettes;

  // Current font suggestions
  List<FontModel> _currentFontSuggestions = [];
  List<FontModel> get currentFontSuggestions => _currentFontSuggestions;

  // Selected image path
  String? _selectedImagePath;
  String? get selectedImagePath => _selectedImagePath;

  void setSelectedColor(Color color) {
    _selectedColor = color;
    notifyListeners();
  }

  void setCurrentScheme(ColorSchemeModel scheme) {
    _currentScheme = scheme;
    notifyListeners();
  }

  void addSavedPalette(ColorSchemeModel palette) {
    _savedPalettes.add(palette);
    notifyListeners();
  }

  void removeSavedPalette(ColorSchemeModel palette) {
    _savedPalettes.remove(palette);
    notifyListeners();
  }

  void setFontSuggestions(List<FontModel> fonts) {
    _currentFontSuggestions = fonts;
    notifyListeners();
  }

  void setSelectedImagePath(String? path) {
    _selectedImagePath = path;
    notifyListeners();
  }

  void clearCurrentSelections() {
    _currentScheme = null;
    _currentFontSuggestions = [];
    _selectedImagePath = null;
    notifyListeners();
  }
}
