import 'package:flutter/material.dart';
import 'package:flutter_started_kit/pages/notification_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Flutter Kit',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold
        ),),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationPage()),
              );
            },
            icon: const Icon(Icons.notifications_none),
            color: Colors.white,
            tooltip: 'Bildirimler',
          )
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.orange,
        ),
      ),
      body: const Center(
        child: Text('Hello, World!'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.purple,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Anasayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Ayarlar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}