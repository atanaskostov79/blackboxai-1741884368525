import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../models/color_scheme_model.dart';
import '../utils/color_utils.dart';
import '../widgets/color_scheme_preview.dart';
import '../widgets/color_info_card.dart';

class ColorPickerScreen extends StatefulWidget {
  const ColorPickerScreen({super.key});

  @override
  State<ColorPickerScreen> createState() => _ColorPickerScreenState();
}

class _ColorPickerScreenState extends State<ColorPickerScreen> {
  late Color pickerColor;
  late ColorSchemeModel currentScheme;
  final TextEditingController _hexController = TextEditingController();

  @override
  void initState() {
    super.initState();
    pickerColor = Provider.of<AppState>(context, listen: false).selectedColor;
    _updateColorScheme();
    _hexController.text = ColorUtils.colorToHex(pickerColor);
  }

  void _updateColorScheme() {
    currentScheme = ColorUtils.generateColorScheme(pickerColor);
    Provider.of<AppState>(context, listen: false).setCurrentScheme(currentScheme);
  }

  void _onColorChanged(Color color) {
    setState(() {
      pickerColor = color;
      _hexController.text = ColorUtils.colorToHex(color);
      _updateColorScheme();
    });
    Provider.of<AppState>(context, listen: false).setSelectedColor(color);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Color Picker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              Provider.of<AppState>(context, listen: false)
                  .addSavedPalette(currentScheme);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Color scheme saved!')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Color',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      ColorPicker(
                        pickerColor: pickerColor,
                        onColorChanged: _onColorChanged,
                        colorPickerWidth: 300,
                        pickerAreaHeightPercent: 0.7,
                        enableAlpha: false,
                        displayThumbColor: true,
                        showLabel: true,
                        paletteType: PaletteType.hsvWithHue,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _hexController,
                              decoration: const InputDecoration(
                                labelText: 'Hex Color',
                                prefixText: '#',
                              ),
                              onSubmitted: (value) {
                                try {
                                  final color = ColorUtils.hexToColor(value);
                                  _onColorChanged(color);
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Invalid hex color code'),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              try {
                                final color =
                                    ColorUtils.hexToColor(_hexController.text);
                                _onColorChanged(color);
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Invalid hex color code'),
                                  ),
                                );
                              }
                            },
                            icon: const Icon(Icons.check),
                            label: const Text('Apply'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Color Harmonies',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              ColorSchemePreview(
                scheme: currentScheme,
                onSave: () {
                  Provider.of<AppState>(context, listen: false)
                      .addSavedPalette(currentScheme);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Color scheme saved!')),
                  );
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Color Information',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              ColorInfoCard(color: pickerColor),
              const SizedBox(height: 24),
              Text(
                'Monochromatic Palette',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: ColorUtils.generateMonochromaticPalette(pickerColor, 5)
                      .map(
                        (color) => Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: InkWell(
                            onTap: () => _onColorChanged(color),
                            child: Container(
                              width: 50,
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
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/font-suggestion');
        },
        icon: const Icon(Icons.text_fields),
        label: const Text('Get Font Suggestions'),
      ),
    );
  }

  @override
  void dispose() {
    _hexController.dispose();
    super.dispose();
  }
}
