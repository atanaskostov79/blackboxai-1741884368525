import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../models/font_model.dart';
import '../utils/font_utils.dart';
import '../utils/color_utils.dart';

class FontSuggestionScreen extends StatefulWidget {
  const FontSuggestionScreen({super.key});

  @override
  State<FontSuggestionScreen> createState() => _FontSuggestionScreenState();
}

class _FontSuggestionScreenState extends State<FontSuggestionScreen> {
  List<FontPairing> _fontPairings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFontSuggestions();
  }

  Future<void> _loadFontSuggestions() async {
    final color = Provider.of<AppState>(context, listen: false).selectedColor;
    final suggestions = FontUtils.getFontSuggestionsForColor(color);

    if (suggestions.isNotEmpty) {
      final pairings = FontUtils.getFontPairings(suggestions.first);
      setState(() {
        _fontPairings = pairings;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedColor = Provider.of<AppState>(context).selectedColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Font Suggestions'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildColorPreview(selectedColor),
                    const SizedBox(height: 24),
                    Text(
                      'Recommended Font Pairings',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    ..._buildFontPairings(),
                    const SizedBox(height: 24),
                    _buildTypographyScales(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildColorPreview(Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selected Color',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ColorUtils.colorToHex(color),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      'RGB(${color.red}, ${color.green}, ${color.blue})',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFontPairings() {
    return _fontPairings.map((pairing) {
      return Card(
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Heading: ${pairing.headingFont.displayName}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                'Body: ${pairing.bodyFont.displayName}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              pairing.getPreview(
                'The Quick Brown Fox',
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Chip(
                    label: Text(pairing.headingFont.category),
                    backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                  ),
                  Chip(
                    label: Text(pairing.bodyFont.category),
                    backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget _buildTypographyScales() {
    if (_fontPairings.isEmpty) return const SizedBox();

    final firstPairing = _fontPairings.first;
    final typographyScale = FontUtils.getTypographyScale(
      firstPairing.headingFont,
      firstPairing.bodyFont,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Typography Scale',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: typographyScale.getPreview(),
          ),
        ),
      ],
    );
  }
}
