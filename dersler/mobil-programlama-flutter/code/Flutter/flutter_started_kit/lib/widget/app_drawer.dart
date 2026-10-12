import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.orange,
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text("🌸"),            
            ),
            accountName: Text('Hamit Seyrek'),
            accountEmail: Text('hamitseyrek@gmail.com'),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
            children: [
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Anasayfa'),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Profil'),
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Ayarlar'),
              ),
            ],
          )),
          Divider(height: 1),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Çıkış Yap', style: TextStyle(color: Colors.red),),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Divider(height: 12),
        ],
      ),
    );
  }
}