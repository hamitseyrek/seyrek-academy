import 'package:flutter/material.dart';
import 'package:ui_component_app/decaration_layout_page.dart.dart';
import 'package:ui_component_app/widget_state_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: MyCenter(),
    );
  }
}

class MyCenter extends StatelessWidget {
  const MyCenter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FilledButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const DecarationLayoutPage(),
              ),
            ),
            onLongPress: () => print('Uzun basıldı'),
            child: Text('Decoration Page'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const WidgetStateThemePage(),
              ),
            ),
            child: Text('Widget State Page'),
          ),
          FilledButton(
            onPressed: () => print('Tıklandı'),
            onLongPress: () => print('Uzun basıldı'),
            child: Text('Tıkla'),
          ),
          FilledButton(
            onPressed: () => print('Tıklandı'),
            onLongPress: () => print('Uzun basıldı'),
            child: Text('Tıkla'),
          ),
        ],
      ),
    );
  }
}