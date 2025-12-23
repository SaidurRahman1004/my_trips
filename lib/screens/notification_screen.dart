import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:my_trips/widgets/CustomText.dart';
import 'package:my_trips/widgets/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $urlString');
      }
    } catch (e) {
      throw Exception('Could not launch $urlString');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> notificationStream = FirebaseFirestore.instance
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .snapshots();
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
      body: StreamBuilder(
        stream: notificationStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off_outlined,
                      size: 80, color: Colors.grey.shade300),
                  const SizedBox(height: 10),
                  Txt(txt: 'No notifications yet',color: Colors.grey,)
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: SafeArea(
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (_, index) {
                  final data = snapshot.data!.docs[index].data() as Map<String,dynamic>;

                  String title = data['title'] ?? 'Notice';
                  String body = data['body'] ?? '';
                  String type = data['type'] ?? 'info'; // 'update' or 'info'
                  String? link = data['link'];
                  Timestamp? timestamp = data['createdAt'];

                  String time = timestamp != null ?
                      DateFormat('dd MMM, hh:mm a').format(timestamp.toDate()) : '';
                  return Card(
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
                        title:  Txt(txt: title),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Txt(txt: body,color: Colors.grey,),
                             SizedBox(height: 10),
                             Txt(txt: time),

                            if (type == 'update' && link != null && link.isNotEmpty)...[
                              const SizedBox(height: 12),
                              SizedBox(
                                  height: 35,
                                  width: 100,
                                  child: CustomButton(buttonName: 'View', onPressed: ()=> _launchUrl(link))),

                            ]

                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }
      ),
    );
  }
}
