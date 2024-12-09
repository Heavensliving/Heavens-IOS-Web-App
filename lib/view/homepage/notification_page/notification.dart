import 'package:flutter/material.dart';
import 'package:heavens_students/controller/homepage_controller/HomepageController.dart';
import 'package:heavens_students/core/constants/constants.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    super.initState();
    // Generate notifications on initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final homepageController = context.read<HomepageController>();
      homepageController.generateNotifications();
      setState(() {}); // Trigger UI rebuild to display notifications
    });
  }

  @override
  Widget build(BuildContext context) {
    final homepageController = context.watch<HomepageController>();

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Notifications",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: homepageController.notifications.isEmpty
            ? Center(
                child: Text(
                  "No notifications available",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
            : ListView.builder(
                itemCount: homepageController.notifications.length,
                itemBuilder: (context, index) {
                  final notification = homepageController.notifications[
                      homepageController.notifications.length - 1 - index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      title: Text(
                        notification.title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: ColorConstants.dark_red),
                      ),
                      subtitle: Text(notification.description),
                    ),
                  );
                },
              ));
  }
}
