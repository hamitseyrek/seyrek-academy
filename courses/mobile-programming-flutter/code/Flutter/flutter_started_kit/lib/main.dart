import 'package:flutter/material.dart';
import 'package:flutter_started_kit/pages/notification_page.dart';
import 'package:flutter_started_kit/pages/page_one.dart';
import 'package:flutter_started_kit/pages/page_three.dart';
import 'package:flutter_started_kit/pages/page_two.dart';
import 'package:flutter_started_kit/widget/app_bottom_nav_bar.dart';
import 'package:flutter_started_kit/widget/app_drawer.dart';

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

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = [
    PageOne(),
    PageTwo(),
    PageThree(),
  ];
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
      drawer: AppDrawer(),
      body: _pages[_selectedIndex],
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}