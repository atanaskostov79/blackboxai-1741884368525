import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/color_scheme_model.dart';

class ColorUtils {
  // Convert RGB to HSL
  static List<double> rgbToHsl(int r, int g, int b) {
    double rf = r / 255;
    double gf = g / 255;
    double bf = b / 255;

    double max = [rf, gf, bf].reduce(math.max);
    double min = [rf, gf, bf].reduce(math.min);
    
    double h = 0;
    double s = 0;
    double l = (max + min) / 2;

    if (max != min) {
      double d = max - min;
      s = l > 0.5 ? d / (2 - max - min) : d / (max + min);
      
      if (max == rf) {
        h = (gf - bf) / d + (gf < bf ? 6 : 0);
      } else if (max == gf) {
        h = (bf - rf) / d + 2;
      } else if (max == bf) {
        h = (rf - gf) / d + 4;
      }
      
      h /= 6;
    }

    return [h * 360, s * 100, l * 100];
  }

  // Convert HSL to RGB
  static Color hslToRgb(double h, double s, double l) {
    h = h / 360;
    s = s / 100;
    l = l / 100;

    double r, g, b;

    if (s == 0) {
      r = g = b = l;
    } else {
      double q = l < 0.5 ? l * (1 + s) : l + s - l * s;
      double p = 2 * l - q;
      r = _hueToRgb(p, q, h + 1/3);
      g = _hueToRgb(p, q, h);
      b = _hueToRgb(p, q, h - 1/3);
    }

    return Color.fromRGBO(
      (r * 255).round(),
      (g * 255).round(),
      (b * 255).round(),
      1,
    );
  }

  static double _hueToRgb(double p, double q, double t) {
    if (t < 0) t += 1;
    if (t > 1) t -= 1;
    if (t < 1/6) return p + (q - p) * 6 * t;
    if (t < 1/2) return q;
    if (t < 2/3) return p + (q - p) * (2/3 - t) * 6;
    return p;
  }

  // Get complementary color
  static Color getComplementaryColor(Color color) {
    final rgb = [color.red, color.green, color.blue];
    final hsl = rgbToHsl(rgb[0], rgb[1], rgb[2]);
    
    // Rotate hue by 180 degrees
    double newHue = (hsl[0] + 180) % 360;
    return hslToRgb(newHue, hsl[1], hsl[2]);
  }

  // Get analogous colors
  static List<Color> getAnalogousColors(Color color) {
    final rgb = [color.red, color.green, color.blue];
    final hsl = rgbToHsl(rgb[0], rgb[1], rgb[2]);
    
    return [
      hslToRgb((hsl[0] - 30 + 360) % 360, hsl[1], hsl[2]),
      hslToRgb((hsl[0] + 30) % 360, hsl[1], hsl[2]),
    ];
  }

  // Get triadic colors
  static List<Color> getTriadicColors(Color color) {
    final rgb = [color.red, color.green, color.blue];
    final hsl = rgbToHsl(rgb[0], rgb[1], rgb[2]);
    
    return [
      hslToRgb((hsl[0] + 120) % 360, hsl[1], hsl[2]),
      hslToRgb((hsl[0] + 240) % 360, hsl[1], hsl[2]),
    ];
  }

  // Generate a complete color scheme
  static ColorSchemeModel generateColorScheme(Color baseColor) {
    return ColorSchemeModel(
      baseColor: baseColor,
      complementaryColor: getComplementaryColor(baseColor),
      analogousColors: getAnalogousColors(baseColor),
      triadicColors: getTriadicColors(baseColor),
    );
  }

  // Convert color to hex string
  static String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';
  }

  // Convert hex string to color
  static Color hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.parse(hex, radix: 16));
  }

  // Check if a color is light or dark
  static bool isLightColor(Color color) {
    return color.computeLuminance() > 0.5;
  }

  // Get a contrasting text color (black or white) based on background
  static Color getContrastingTextColor(Color backgroundColor) {
    return isLightColor(backgroundColor) ? Colors.black : Colors.white;
  }

  // Generate a monochromatic palette
  static List<Color> generateMonochromaticPalette(Color baseColor, int steps) {
    final rgb = [baseColor.red, baseColor.green, baseColor.blue];
    final hsl = rgbToHsl(rgb[0], rgb[1], rgb[2]);
    
    List<Color> palette = [];
    double lightnessDelta = (100 - hsl[2]) / (steps - 1);
    
    for (int i = 0; i < steps; i++) {
      palette.add(hslToRgb(hsl[0], hsl[1], math.min(100, hsl[2] + lightnessDelta * i)));
    }
    
    return palette;
  }

  // Check color accessibility (WCAG contrast ratio)
  static double getContrastRatio(Color color1, Color color2) {
    double l1 = color1.computeLuminance();
    double l2 = color2.computeLuminance();
    
    double lighter = math.max(l1, l2);
    double darker = math.min(l1, l2);
    
    return (lighter + 0.05) / (darker + 0.05);
  }

  // Suggest accessible text colors
  static List<Color> suggestAccessibleTextColors(Color backgroundColor) {
    List<Color> suggestions = [];
    
    if (getContrastRatio(backgroundColor, Colors.black) >= 4.5) {
      suggestions.add(Colors.black);
    }
    if (getContrastRatio(backgroundColor, Colors.white) >= 4.5) {
      suggestions.add(Colors.white);
    }
    
    return suggestions;
  }
}
