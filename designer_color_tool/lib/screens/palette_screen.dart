import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../models/color_scheme_model.dart';
import '../utils/color_utils.dart';

class PaletteScreen extends StatelessWidget {
  const PaletteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Palettes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              _showSortOptions(context);
            },
          ),
        ],
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          if (appState.savedPalettes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.palette_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No saved palettes yet',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your saved color schemes will appear here',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: appState.savedPalettes.length,
            itemBuilder: (context, index) {
              return _PaletteCard(
                scheme: appState.savedPalettes[index],
                onDelete: () {
                  appState.removeSavedPalette(appState.savedPalettes[index]);
                },
                onSelect: () {
                  appState.setSelectedColor(appState.savedPalettes[index].baseColor);
                  appState.setCurrentScheme(appState.savedPalettes[index]);
                  Navigator.pushNamed(context, '/color-picker');
                },
              );
            },
          );
        },
      ),
    );
  }

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.access_time),
                title: const Text('Sort by Date'),
                onTap: () {
                  // Implement date sorting
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.color_lens),
                title: const Text('Sort by Color'),
                onTap: () {
                  // Implement color sorting
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.brightness_6),
                title: const Text('Sort by Brightness'),
                onTap: () {
                  // Implement brightness sorting
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PaletteCard extends StatelessWidget {
  final ColorSchemeModel scheme;
  final VoidCallback onDelete;
  final VoidCallback onSelect;

  const _PaletteCard({
    required this.scheme,
    required this.onDelete,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onSelect,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        color: scheme.baseColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: scheme.complementaryColor,
                    ),
                  ),
                  ...scheme.analogousColors.map(
                    (color) => Expanded(
                      child: Container(color: color),
                    ),
                  ),
                  ...scheme.triadicColors.map(
                    (color) => Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: color == scheme.triadicColors.last
                              ? const BorderRadius.only(
                                  topRight: Radius.circular(12),
                                )
                              : null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      scheme.name ?? 'Unnamed Palette',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () {
                        _showDeleteConfirmation(context);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: scheme.getHexCodes().map((hex) {
                    return Chip(
                      label: Text(
                        hex,
                        style: TextStyle(
                          color: ColorUtils.getContrastingTextColor(
                            ColorUtils.hexToColor(hex),
                          ),
                        ),
                      ),
                      backgroundColor: ColorUtils.hexToColor(hex),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      icon: const Icon(Icons.copy),
                      label: const Text('Copy Colors'),
                      onPressed: () {
                        _copyColorsToClipboard(context);
                      },
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      icon: const Icon(Icons.text_fields),
                      label: const Text('Font Suggestions'),
                      onPressed: () {
                        Navigator.pushNamed(context, '/font-suggestion');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Palette'),
          content: const Text('Are you sure you want to delete this color palette?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop();
                onDelete();
              },
            ),
          ],
        );
      },
    );
  }

  void _copyColorsToClipboard(BuildContext context) {
    final hexCodes = scheme.getHexCodes().join(', ');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Colors copied to clipboard'),
        action: SnackBarAction(
          label: 'View',
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Copied Colors'),
                  content: Text(hexCodes),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Close'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
