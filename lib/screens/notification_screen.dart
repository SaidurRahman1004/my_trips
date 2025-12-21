import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:my_trips/widgets/CenterCircularProgressIndicator.dart';
import 'package:my_trips/widgets/CustomText.dart';
import 'package:my_trips/widgets/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  Future<void> _launchUrl(String urlString) async {
    if (urlString.isEmpty) return;

    final Uri url = Uri.parse(urlString);
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      debugPrint("Error launching URL: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _notificationsStream = FirebaseFirestore
        .instance
        .collection('notifications')
        .orderBy('timestamp', descending: true)
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        title: const Txt(txt: 'Notifications'),
        elevation: 2,
        centerTitle: true,
        backgroundColor: Colors.grey.shade50,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(Icons.arrow_back_outlined),
        ),
      ),
      body: StreamBuilder(
        stream: _notificationsStream,

        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CenterCircularProgressIndicator();
          }
          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off_outlined,
                    size: 80,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 10),
                  const Txt(txt: "No notifications yet", color: Colors.grey),
                ],
              ),
            );
          }
          return SafeArea(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (_, index) {
                Map<String, dynamic> data =
                    snapshot.data!.docs[index].data()! as Map<String, dynamic>;
                String formattedDate = "Just now";
                if (data['timestamp'] != null) {
                  Timestamp t = data['timestamp'];
                  formattedDate = DateFormat(
                    'dd MMM yyyy, h:mm a',
                  ).format(t.toDate());
                }
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
                      title: Txt(txt: data['title'] ?? 'No Title'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Txt(txt: data['body'] ?? 'No Description'),
                          const SizedBox(height: 4),
                          Txt(txt: formattedDate, color: Colors.grey),
                          const SizedBox(height: 4),
                          if (data['link'] != null && data['link'].toString().isNotEmpty) ...[
                            SizedBox(
                              height: 35,
                              width: 100,
                              child: CustomButton(
                                buttonName: 'View',
                                onPressed: () => _launchUrl(data['link']),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
