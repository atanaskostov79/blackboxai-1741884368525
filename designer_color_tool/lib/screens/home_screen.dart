import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../widgets/feature_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            floating: true,
            pinned: true,
            title: const Text(
              'Designer Color Tool',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.surface,
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 400.0,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
                childAspectRatio: 1.2,
              ),
              delegate: SliverChildListDelegate([
                FeatureCard(
                  title: 'Color Picker',
                  description: 'Choose colors and get harmonious combinations',
                  icon: Icons.color_lens,
                  color: Colors.blue,
                  onTap: () => Navigator.pushNamed(context, '/color-picker'),
                ),
                FeatureCard(
                  title: 'Extract from Image',
                  description: 'Extract color palettes from your images',
                  icon: Icons.image,
                  color: Colors.green,
                  onTap: () => Navigator.pushNamed(context, '/image-extraction'),
                ),
                FeatureCard(
                  title: 'Color Palettes',
                  description: 'Browse and save color combinations',
                  icon: Icons.palette,
                  color: Colors.orange,
                  onTap: () => Navigator.pushNamed(context, '/palette'),
                ),
                FeatureCard(
                  title: 'Font Suggestions',
                  description: 'Get font recommendations for your colors',
                  icon: Icons.text_fields,
                  color: Colors.purple,
                  onTap: () => Navigator.pushNamed(context, '/font-suggestion'),
                ),
              ]),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverToBoxAdapter(
              child: _buildRecentSection(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSection(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        if (appState.savedPalettes.isEmpty) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent Work',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Your recent color palettes and designs will appear here.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recent Work',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: appState.savedPalettes.length,
                    itemBuilder: (context, index) {
                      final palette = appState.savedPalettes[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: _buildPalettePreview(palette, context),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPalettePreview(colorScheme, BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/palette'),
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: colorScheme.getAllColors().map<Widget>((color) {
            return Expanded(
              child: Container(
                height: 100,
                color: color,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
