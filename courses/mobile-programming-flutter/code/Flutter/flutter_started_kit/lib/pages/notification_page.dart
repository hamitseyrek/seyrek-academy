import 'package:flutter/material.dart';
import 'package:flutter_started_kit/data/notification_dummy_data.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bildirimler'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: dummyNotifications.length,
        itemBuilder: (context, index) {
          final notification = dummyNotifications[index];
          return Card(
            margin: const EdgeInsets.all(6),
            elevation: 3,
            child: ListTile(
              leading: CircleAvatar(
                child: Text(notification.emoji),
              ),
              title: Text(notification.user),
              subtitle: Text(notification.message),
              trailing: Text(notification.time,
                style: TextStyle(color: Colors.grey, fontSize: 12),),
            ),
          );
        }
      ),
    );
  }
}