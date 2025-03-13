import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../models/color_scheme_model.dart';
import '../utils/image_utils.dart';
import '../utils/color_utils.dart';
import '../widgets/color_scheme_preview.dart';

class ImageColorExtractionScreen extends StatefulWidget {
  const ImageColorExtractionScreen({super.key});

  @override
  State<ImageColorExtractionScreen> createState() =>
      _ImageColorExtractionScreenState();
}

class _ImageColorExtractionScreenState extends State<ImageColorExtractionScreen> {
  File? _selectedImage;
  bool _isProcessing = false;
  List<Color> _extractedColors = [];
  ColorMood? _colorMood;
  ColorSchemeModel? _generatedScheme;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _isProcessing = true;
          _extractedColors = [];
          _colorMood = null;
          _generatedScheme = null;
        });

        // Process the image
        final List<Color> colors = await ImageUtils.extractPalette(image.path);
        final ColorMood mood = await ImageUtils.analyzeColorMood(image.path);
        final dominantColor = await ImageUtils.extractDominantColor(image.path);
        final scheme = ColorUtils.generateColorScheme(dominantColor);

        setState(() {
          _extractedColors = colors;
          _colorMood = mood;
          _generatedScheme = scheme;
          _isProcessing = false;
        });

        // Update app state
        Provider.of<AppState>(context, listen: false)
          ..setSelectedColor(dominantColor)
          ..setCurrentScheme(scheme)
          ..setSelectedImagePath(image.path);
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error processing image: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Extract Colors from Image'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageSection(),
              if (_isProcessing) ...[
                const SizedBox(height: 24),
                const Center(
                  child: CircularProgressIndicator(),
                ),
              ],
              if (_extractedColors.isNotEmpty) ...[
                const SizedBox(height: 24),
                _buildExtractedColorsSection(),
              ],
              if (_colorMood != null) ...[
                const SizedBox(height: 24),
                _buildColorMoodSection(),
              ],
              if (_generatedScheme != null) ...[
                const SizedBox(height: 24),
                Text(
                  'Generated Color Scheme',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                ColorSchemePreview(
                  scheme: _generatedScheme!,
                  onSave: () {
                    Provider.of<AppState>(context, listen: false)
                        .addSavedPalette(_generatedScheme!);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Color scheme saved!')),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Choose from Gallery'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Take Photo'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_selectedImage != null)
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.file(
                  _selectedImage!,
                  fit: BoxFit.cover,
                ),
              ),
            )
          else
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Select an image to extract colors',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildExtractedColorsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Extracted Colors',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _extractedColors.length,
            itemBuilder: (context, index) {
              final color = _extractedColors[index];
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: InkWell(
                  onTap: () {
                    Provider.of<AppState>(context, listen: false)
                        .setSelectedColor(color);
                    final scheme = ColorUtils.generateColorScheme(color);
                    setState(() {
                      _generatedScheme = scheme;
                    });
                  },
                  child: Container(
                    width: 60,
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
                    child: Center(
                      child: Icon(
                        Icons.colorize,
                        color: ColorUtils.getContrastingTextColor(color),
                      ),
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

  Widget _buildColorMoodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color Mood',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _colorMood!.description,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                const Text('Suggested Use Cases:'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _colorMood!.suggestedUseCases.map((useCase) {
                    return Chip(
                      label: Text(useCase),
                      backgroundColor:
                          Theme.of(context).colorScheme.surfaceVariant,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
