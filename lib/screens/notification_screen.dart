import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_trips/widgets/CustomText.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Txt(txt: 'Notifications'),
        elevation: 4,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            context.pop(true);
          },
          icon: Icon(Icons.arrow_back_outlined),
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemBuilder: (_, index) {
            return Expanded(
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.amber.shade100,
                      radius: 20,
                      child: Icon(Icons.notifications, color: Colors.amber),
                    ),
                    title: const Txt(txt: 'Title'),
                    subtitle: Column(
                      children: [
                        const Txt(txt: 'Description'),
                        const SizedBox(height: 4),
                        const Txt(txt: 'date'),
                        const SizedBox(height: 4),

                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
