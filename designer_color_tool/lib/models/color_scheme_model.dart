import 'package:flutter/material.dart';

class ColorSchemeModel {
  final Color baseColor;
  final Color complementaryColor;
  final List<Color> analogousColors;
  final List<Color> triadicColors;
  final String? name;
  final DateTime createdAt;

  ColorSchemeModel({
    required this.baseColor,
    required this.complementaryColor,
    required this.analogousColors,
    required this.triadicColors,
    this.name,
  }) : createdAt = DateTime.now();

  // Convert to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'baseColor': baseColor.value,
      'complementaryColor': complementaryColor.value,
      'analogousColors': analogousColors.map((c) => c.value).toList(),
      'triadicColors': triadicColors.map((c) => c.value).toList(),
      'name': name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create from Map for storage retrieval
  factory ColorSchemeModel.fromMap(Map<String, dynamic> map) {
    return ColorSchemeModel(
      baseColor: Color(map['baseColor'] as int),
      complementaryColor: Color(map['complementaryColor'] as int),
      analogousColors: (map['analogousColors'] as List)
          .map((value) => Color(value as int))
          .toList(),
      triadicColors: (map['triadicColors'] as List)
          .map((value) => Color(value as int))
          .toList(),
      name: map['name'] as String?,
    );
  }

  // Create a copy with optional new values
  ColorSchemeModel copyWith({
    Color? baseColor,
    Color? complementaryColor,
    List<Color>? analogousColors,
    List<Color>? triadicColors,
    String? name,
  }) {
    return ColorSchemeModel(
      baseColor: baseColor ?? this.baseColor,
      complementaryColor: complementaryColor ?? this.complementaryColor,
      analogousColors: analogousColors ?? this.analogousColors,
      triadicColors: triadicColors ?? this.triadicColors,
      name: name ?? this.name,
    );
  }

  // Get all colors in the scheme as a list
  List<Color> getAllColors() {
    return [
      baseColor,
      complementaryColor,
      ...analogousColors,
      ...triadicColors,
    ];
  }

  // Get hex codes for all colors
  List<String> getHexCodes() {
    return getAllColors().map((color) {
      return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';
    }).toList();
  }
}
