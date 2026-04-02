import 'package:flutter/material.dart';
import 'package:ui_component_app/section_title.dart';

class WidgetStateThemePage extends StatefulWidget {
  const WidgetStateThemePage({super.key});

  @override
  State<WidgetStateThemePage> createState() => _WidgetStateThemePageState();
}

class _WidgetStateThemePageState extends State<WidgetStateThemePage> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('State ve tema')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          const SectionTitle('Theme.of(context)'),
          Text(
            'OnPrimary rengi örneği',
            style: TextStyle(color: scheme.onPrimary),
          ),
          const SectionTitle('StatefulWidget + setState'),
          Text('Sayaç: $_counter', style: Theme.of(context).textTheme.headlineSmall),
          FilledButton(
            onPressed: () {
              setState(() => _counter++);
            },
            child: const Text('Artır'),
          ),
          const SectionTitle('CircleAvatar — ağ ve varlık'),
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundImage: NetworkImage('https://picsum.photos/200'),
              ),
              const SizedBox(width: 16),
              CircleAvatar(
                radius: 32,
                backgroundColor: Colors.amber,
              ),
            ],
          ),
          const SectionTitle('FadeInImage + Placeholder'),
          FadeInImage.assetNetwork(
            placeholderColor: Colors.blue,
            placeholder: 'assets/placeholder.png',
            image: 'https://picsum.photos/400/200',
            height: 120,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          const SectionTitle('Placeholder — henüz tasarlanmamış alan'),
          const SizedBox(
            height: 80,
            child: Placeholder(),
          ),
          const SectionTitle('IntrinsicHeight — yan yana eşit yükseklik'),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    color: Colors.teal.shade100,
                    child: const Center(child: Text('Kısa')),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.teal.shade200,
                    child: const Center(
                      child: Text('Daha uzun\nmetin'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        ),
      ),
    );
  }
}