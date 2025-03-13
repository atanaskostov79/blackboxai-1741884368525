import 'package:flutter/material.dart';
import '../models/font_model.dart';
import 'color_utils.dart';

class FontUtils {
  // Predefined font categories
  static const Map<String, List<FontModel>> fontCategories = {
    'modern': [
      FontModel(
        fontFamily: 'Roboto',
        displayName: 'Roboto',
        category: 'sans-serif',
        description: 'Clean and modern sans-serif font',
        suggestedPairings: ['Playfair Display', 'Lora', 'Merriweather'],
        styleFunction: GoogleFonts.roboto,
      ),
      // Add more modern fonts...
    ],
    'classic': [
      FontModel(
        fontFamily: 'Merriweather',
        displayName: 'Merriweather',
        category: 'serif',
        description: 'Classic serif font with excellent readability',
        suggestedPairings: ['Roboto', 'Open Sans', 'Source Sans Pro'],
        styleFunction: GoogleFonts.merriweather,
      ),
      // Add more classic fonts...
    ],
    'creative': [
      FontModel(
        fontFamily: 'Pacifico',
        displayName: 'Pacifico',
        category: 'handwriting',
        description: 'Playful handwriting font for creative designs',
        suggestedPairings: ['Roboto', 'Open Sans', 'Lato'],
        styleFunction: GoogleFonts.pacifico,
      ),
      // Add more creative fonts...
    ],
  };

  // Get font suggestions based on color
  static List<FontModel> getFontSuggestionsForColor(Color color) {
    final List<FontModel> suggestions = [];
    final hsl = ColorUtils.rgbToHsl(color.red, color.green, color.blue);
    
    // Hue-based suggestions
    double hue = hsl[0];
    double saturation = hsl[1];
    double lightness = hsl[2];

    // Warm colors (reds, oranges, yellows)
    if ((hue >= 0 && hue <= 60) || hue >= 300) {
      suggestions.addAll(fontCategories['classic'] ?? []);
    }
    
    // Cool colors (blues, greens)
    if (hue > 60 && hue < 300) {
      suggestions.addAll(fontCategories['modern'] ?? []);
    }

    // High saturation suggests creative fonts
    if (saturation > 60) {
      suggestions.addAll(fontCategories['creative'] ?? []);
    }

    // Remove duplicates
    return suggestions.toSet().toList();
  }

  // Get font pairing suggestions
  static List<FontPairing> getFontPairings(FontModel baseFont) {
    List<FontPairing> pairings = [];
    
    for (String suggestedFamily in baseFont.suggestedPairings) {
      // Find the suggested font in our categories
      FontModel? pairedFont;
      for (var category in fontCategories.values) {
        pairedFont = category.firstWhere(
          (font) => font.fontFamily == suggestedFamily,
          orElse: () => null,
        );
        if (pairedFont != null) break;
      }
      
      if (pairedFont != null) {
        pairings.add(FontPairing(
          headingFont: baseFont,
          bodyFont: pairedFont,
        ));
      }
    }
    
    return pairings;
  }

  // Get a complete typography scale
  static TypographyScale getTypographyScale(FontModel headingFont, FontModel bodyFont) {
    return TypographyScale(
      h1: headingFont.styleFunction(
        const TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          height: 1.2,
        ),
      ),
      h2: headingFont.styleFunction(
        const TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          height: 1.25,
        ),
      ),
      h3: headingFont.styleFunction(
        const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          height: 1.3,
        ),
      ),
      body1: bodyFont.styleFunction(
        const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          height: 1.5,
        ),
      ),
      body2: bodyFont.styleFunction(
        const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          height: 1.6,
        ),
      ),
      caption: bodyFont.styleFunction(
        const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          height: 1.4,
        ),
      ),
    );
  }
}

// Helper classes for font pairing and typography
class FontPairing {
  final FontModel headingFont;
  final FontModel bodyFont;

  FontPairing({
    required this.headingFont,
    required this.bodyFont,
  });

  Widget getPreview(String headingText, String bodyText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          headingText,
          style: headingFont.getHeadingStyle(),
        ),
        const SizedBox(height: 8),
        Text(
          bodyText,
          style: bodyFont.getBodyStyle(),
        ),
      ],
    );
  }
}

class TypographyScale {
  final TextStyle h1;
  final TextStyle h2;
  final TextStyle h3;
  final TextStyle body1;
  final TextStyle body2;
  final TextStyle caption;

  TypographyScale({
    required this.h1,
    required this.h2,
    required this.h3,
    required this.body1,
    required this.body2,
    required this.caption,
  });

  Widget getPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Heading 1', style: h1),
        const SizedBox(height: 16),
        Text('Heading 2', style: h2),
        const SizedBox(height: 16),
        Text('Heading 3', style: h3),
        const SizedBox(height: 16),
        Text('Body 1 Text', style: body1),
        const SizedBox(height: 8),
        Text('Body 2 Text', style: body2),
        const SizedBox(height: 8),
        Text('Caption Text', style: caption),
      ],
    );
  }
}
