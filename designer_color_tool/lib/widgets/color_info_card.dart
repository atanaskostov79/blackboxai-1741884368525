import 'package:flutter/material.dart';
import '../utils/color_utils.dart';

class ColorInfoCard extends StatelessWidget {
  final Color color;

  const ColorInfoCard({
    super.key,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final hsl = ColorUtils.rgbToHsl(color.red, color.green, color.blue);
    final contrastWithWhite = ColorUtils.getContrastRatio(color, Colors.white);
    final contrastWithBlack = ColorUtils.getContrastRatio(color, Colors.black);
    final isLightColor = ColorUtils.isLightColor(color);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
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
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ColorUtils.colorToHex(color),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'RGB(${color.red}, ${color.green}, ${color.blue})',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            _buildInfoSection(
              context,
              'HSL Values',
              [
                'Hue: ${hsl[0].toStringAsFixed(1)}°',
                'Saturation: ${hsl[1].toStringAsFixed(1)}%',
                'Lightness: ${hsl[2].toStringAsFixed(1)}%',
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoSection(
              context,
              'Contrast Ratios',
              [
                'With White: ${contrastWithWhite.toStringAsFixed(2)}',
                'With Black: ${contrastWithBlack.toStringAsFixed(2)}',
              ],
            ),
            const SizedBox(height: 16),
            _buildAccessibilityInfo(context, contrastWithWhite, contrastWithBlack),
            const SizedBox(height: 16),
            _buildColorCharacteristics(context, hsl, isLightColor),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(
    BuildContext context,
    String title,
    List<String> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              item,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAccessibilityInfo(
    BuildContext context,
    double contrastWithWhite,
    double contrastWithBlack,
  ) {
    final bestContrast = contrastWithWhite > contrastWithBlack
        ? ('White text (${contrastWithWhite.toStringAsFixed(2)}:1)')
        : ('Black text (${contrastWithBlack.toStringAsFixed(2)}:1)');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Accessibility',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Best contrast with: $bestContrast',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 4),
        Text(
          _getWCAGGuideline(
            math.max(contrastWithWhite, contrastWithBlack),
          ),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
        ),
      ],
    );
  }

  String _getWCAGGuideline(double contrast) {
    if (contrast >= 7) {
      return 'Meets WCAG AAA standards for all text';
    } else if (contrast >= 4.5) {
      return 'Meets WCAG AA standards for normal text';
    } else if (contrast >= 3) {
      return 'Meets WCAG AA standards for large text only';
    } else {
      return 'Does not meet WCAG contrast requirements';
    }
  }

  Widget _buildColorCharacteristics(
    BuildContext context,
    List<double> hsl,
    bool isLightColor,
  ) {
    final characteristics = <String>[];

    // Temperature
    if (hsl[0] < 60 || hsl[0] > 300) {
      characteristics.add('Warm');
    } else {
      characteristics.add('Cool');
    }

    // Intensity
    if (hsl[1] > 70) {
      characteristics.add('Vibrant');
    } else if (hsl[1] < 30) {
      characteristics.add('Muted');
    }

    // Brightness
    if (isLightColor) {
      characteristics.add('Light');
    } else {
      characteristics.add('Dark');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Characteristics',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: characteristics.map((characteristic) {
            return Chip(
              label: Text(characteristic),
              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            );
          }).toList(),
        ),
      ],
    );
  }
}
