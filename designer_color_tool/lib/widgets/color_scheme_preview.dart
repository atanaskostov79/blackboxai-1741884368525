import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/color_scheme_model.dart';
import '../utils/color_utils.dart';

class ColorSchemePreview extends StatelessWidget {
  final ColorSchemeModel scheme;
  final VoidCallback onSave;

  const ColorSchemePreview({
    super.key,
    required this.scheme,
    required this.onSave,
  });

  void _copyColorToClipboard(BuildContext context, Color color) {
    final hexCode = ColorUtils.colorToHex(color);
    Clipboard.setData(ClipboardData(text: hexCode));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Copied $hexCode to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHarmonySection(
          'Base Color',
          [scheme.baseColor],
          context,
        ),
        const SizedBox(height: 16),
        _buildHarmonySection(
          'Complementary',
          [scheme.complementaryColor],
          context,
        ),
        const SizedBox(height: 16),
        _buildHarmonySection(
          'Analogous',
          scheme.analogousColors,
          context,
        ),
        const SizedBox(height: 16),
        _buildHarmonySection(
          'Triadic',
          scheme.triadicColors,
          context,
        ),
      ],
    );
  }

  Widget _buildHarmonySection(
    String title,
    List<Color> colors,
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: colors.length,
            itemBuilder: (context, index) {
              final color = colors[index];
              final hexCode = ColorUtils.colorToHex(color);
              final textColor = ColorUtils.getContrastingTextColor(color);

              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: InkWell(
                  onTap: () => _copyColorToClipboard(context, color),
                  child: Container(
                    width: 120,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          hexCode,
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Icon(
                          Icons.content_copy,
                          color: textColor.withOpacity(0.7),
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
