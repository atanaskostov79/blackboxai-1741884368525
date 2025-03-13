import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:palette_generator/palette_generator.dart';
import '../models/color_scheme_model.dart';
import 'color_utils.dart';

class ImageUtils {
  // Extract dominant color from image
  static Future<Color> extractDominantColor(String imagePath) async {
    final File imageFile = File(imagePath);
    final imageBytes = await imageFile.readAsBytes();
    final image = img.decodeImage(imageBytes);

    if (image == null) {
      throw Exception('Failed to decode image');
    }

    // Resize image for faster processing
    final resizedImage = img.copyResize(image, width: 100);
    
    // Calculate average color
    int redTotal = 0;
    int greenTotal = 0;
    int blueTotal = 0;
    int pixelCount = 0;

    for (int y = 0; y < resizedImage.height; y++) {
      for (int x = 0; x < resizedImage.width; x++) {
        final pixel = resizedImage.getPixel(x, y);
        redTotal += img.getRed(pixel);
        greenTotal += img.getGreen(pixel);
        blueTotal += img.getBlue(pixel);
        pixelCount++;
      }
    }

    return Color.fromRGBO(
      redTotal ~/ pixelCount,
      greenTotal ~/ pixelCount,
      blueTotal ~/ pixelCount,
      1.0,
    );
  }

  // Extract color palette from image using PaletteGenerator
  static Future<List<Color>> extractPalette(String imagePath) async {
    final File imageFile = File(imagePath);
    final imageBytes = await imageFile.readAsBytes();
    final codec = await ui.instantiateImageCodec(imageBytes);
    final frame = await codec.getNextFrame();
    final image = frame.image;

    final PaletteGenerator paletteGenerator = await PaletteGenerator.fromImage(
      ImageProvider.memory(imageBytes) as ui.Image,
      maximumColorCount: 8,
    );

    return paletteGenerator.colors.toList();
  }

  // Generate a color scheme based on image
  static Future<ColorSchemeModel> generateSchemeFromImage(String imagePath) async {
    final dominantColor = await extractDominantColor(imagePath);
    return ColorUtils.generateColorScheme(dominantColor);
  }

  // Extract multiple color schemes from image
  static Future<List<ColorSchemeModel>> extractMultipleSchemes(String imagePath) async {
    final List<Color> palette = await extractPalette(imagePath);
    List<ColorSchemeModel> schemes = [];

    for (Color color in palette) {
      schemes.add(ColorUtils.generateColorScheme(color));
    }

    return schemes;
  }

  // Analyze image colors and return color mood
  static Future<ColorMood> analyzeColorMood(String imagePath) async {
    final dominantColor = await extractDominantColor(imagePath);
    final hsl = ColorUtils.rgbToHsl(
      dominantColor.red,
      dominantColor.green,
      dominantColor.blue,
    );

    double hue = hsl[0];
    double saturation = hsl[1];
    double lightness = hsl[2];

    // Determine mood based on color properties
    if (saturation < 20) {
      return ColorMood.neutral;
    } else if (lightness > 80) {
      return ColorMood.light;
    } else if (lightness < 20) {
      return ColorMood.dark;
    } else if (hue >= 0 && hue < 60) {
      return ColorMood.warm;
    } else if (hue >= 180 && hue < 300) {
      return ColorMood.cool;
    } else {
      return ColorMood.vibrant;
    }
  }

  // Get suggested color adjustments for better contrast
  static Future<List<Color>> suggestColorAdjustments(
    String imagePath,
    Color backgroundColor,
  ) async {
    final dominantColor = await extractDominantColor(imagePath);
    List<Color> suggestions = [];

    // Check contrast ratio
    double contrast = ColorUtils.getContrastRatio(dominantColor, backgroundColor);

    if (contrast < 4.5) {
      // Adjust lightness to improve contrast
      final hsl = ColorUtils.rgbToHsl(
        dominantColor.red,
        dominantColor.green,
        dominantColor.blue,
      );

      // Try lighter version
      suggestions.add(ColorUtils.hslToRgb(hsl[0], hsl[1], math.min(100, hsl[2] + 20)));
      
      // Try darker version
      suggestions.add(ColorUtils.hslToRgb(hsl[0], hsl[1], math.max(0, hsl[2] - 20)));
    }

    return suggestions;
  }
}

// Enum for color mood classification
enum ColorMood {
  warm,
  cool,
  neutral,
  vibrant,
  light,
  dark,
}

extension ColorMoodExtension on ColorMood {
  String get description {
    switch (this) {
      case ColorMood.warm:
        return 'Warm and inviting';
      case ColorMood.cool:
        return 'Cool and calming';
      case ColorMood.neutral:
        return 'Neutral and balanced';
      case ColorMood.vibrant:
        return 'Vibrant and energetic';
      case ColorMood.light:
        return 'Light and airy';
      case ColorMood.dark:
        return 'Dark and sophisticated';
    }
  }

  List<String> get suggestedUseCases {
    switch (this) {
      case ColorMood.warm:
        return ['Restaurants', 'Cozy interiors', 'Autumn themes'];
      case ColorMood.cool:
        return ['Corporate', 'Technology', 'Healthcare'];
      case ColorMood.neutral:
        return ['Professional services', 'Minimalist design', 'Background elements'];
      case ColorMood.vibrant:
        return ['Entertainment', 'Youth brands', 'Creative services'];
      case ColorMood.light:
        return ['Weddings', 'Health & wellness', 'Modern minimal'];
      case ColorMood.dark:
        return ['Luxury brands', 'Night themes', 'Premium services'];
    }
  }
}
