import 'package:flutter/material.dart';

class DecarationLayoutPage extends StatelessWidget {
  const DecarationLayoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Decoration Page'),
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: Colors.red, width: 5),
            ),
            child: const Text('Decoration Page'),
          ),

          const SizedBox(height: 20),

          Row(
            children: const [
              Expanded(
                child: SizedBox(height: 100, child: ColoredBox(color: Colors.red)),
              ),
              SizedBox(width: 20),
              Expanded(
                child: SizedBox(height: 100, child: ColoredBox(color: Colors.blue)),
              ),
              SizedBox(width: 20),
              Expanded(
                child: SizedBox(height: 100, child: ColoredBox(color: Colors.green)),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Flexible(
                fit: FlexFit.tight,
                child: Container(
                  color: Colors.purple,
                  padding: const EdgeInsets.all(10),
                  child: const Text('Flexible'),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.orange,
                  padding: const EdgeInsets.all(10),
                  child: const Text('Expanded'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Container(
            height: 150,
            width: 150,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR9LQpyOPv-3jQ5wzWeQhYQ10JbcZ9zGNNL3w&s', 
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}