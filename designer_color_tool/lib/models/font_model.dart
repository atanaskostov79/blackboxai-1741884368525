import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class FontModel {
  final String fontFamily;
  final String displayName;
  final String category; // serif, sans-serif, display, etc.
  final String? description;
  final List<String> suggestedPairings;
  final TextStyle Function(TextStyle) styleFunction;

  FontModel({
    required this.fontFamily,
    required this.displayName,
    required this.category,
    this.description,
    required this.suggestedPairings,
    required this.styleFunction,
  });

  // Get the font style for different text sizes
  TextStyle getHeadingStyle() {
    return styleFunction(
      const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        height: 1.2,
      ),
    );
  }

  TextStyle getSubheadingStyle() {
    return styleFunction(
      const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        height: 1.3,
      ),
    );
  }

  TextStyle getBodyStyle() {
    return styleFunction(
      const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        height: 1.5,
      ),
    );
  }

  // Factory constructors for common Google Fonts
  factory FontModel.roboto() {
    return FontModel(
      fontFamily: 'Roboto',
      displayName: 'Roboto',
      category: 'sans-serif',
      description: 'Modern, clean and readable sans-serif font',
      suggestedPairings: ['Playfair Display', 'Lora', 'Open Sans'],
      styleFunction: GoogleFonts.roboto,
    );
  }

  factory FontModel.playfairDisplay() {
    return FontModel(
      fontFamily: 'Playfair Display',
      displayName: 'Playfair Display',
      category: 'serif',
      description: 'Elegant serif font perfect for headings',
      suggestedPairings: ['Roboto', 'Source Sans Pro', 'Lato'],
      styleFunction: GoogleFonts.playfairDisplay,
    );
  }

  factory FontModel.openSans() {
    return FontModel(
      fontFamily: 'Open Sans',
      displayName: 'Open Sans',
      category: 'sans-serif',
      description: 'Friendly and approachable sans-serif font',
      suggestedPairings: ['Roboto Slab', 'Merriweather', 'Lora'],
      styleFunction: GoogleFonts.openSans,
    );
  }

  // Convert to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'fontFamily': fontFamily,
      'displayName': displayName,
      'category': category,
      'description': description,
      'suggestedPairings': suggestedPairings,
    };
  }

  // Create from Map for storage retrieval
  factory FontModel.fromMap(Map<String, dynamic> map) {
    return FontModel(
      fontFamily: map['fontFamily'] as String,
      displayName: map['displayName'] as String,
      category: map['category'] as String,
      description: map['description'] as String?,
      suggestedPairings: List<String>.from(map['suggestedPairings'] as List),
      styleFunction: GoogleFonts.getFont(map['fontFamily'] as String),
    );
  }

  // Get a preview text with the font
  Widget getPreview(String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text, style: getHeadingStyle()),
        const SizedBox(height: 8),
        Text(text, style: getSubheadingStyle()),
        const SizedBox(height: 8),
        Text(text, style: getBodyStyle()),
      ],
    );
  }

  // Check if this font pairs well with another font
  bool pairsWith(String otherFontFamily) {
    return suggestedPairings.contains(otherFontFamily);
  }
}
