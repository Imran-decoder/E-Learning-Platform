import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime cutoff =
        now.subtract(Duration(hours: 24)); // Show only last 24 hours

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor:
            Color.fromARGB(255, 92, 91, 91), // Optional, for consistent look with your app
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .where('timestamp', isGreaterThan: cutoff)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          var notifications = snapshot.data!.docs;
          if (notifications.isEmpty) {
            return const Center(
                child: Text("No new notifications in the last 24 hours."));
          }

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              var data = notifications[index].data() as Map<String, dynamic>;
              DateTime timestamp = (data['timestamp'] as Timestamp).toDate();
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: data['image'] != null && data['image'].isNotEmpty
                      ? Image.network(data['image'],
                          width: 50, height: 50, fit: BoxFit.cover)
                      : const Icon(Icons.notifications, size: 40),
                  title: Text(data['title'],
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data['body']),
                      const SizedBox(height: 5),
                      Text(
                        DateFormat('MMM d, h:mm a').format(timestamp),
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
