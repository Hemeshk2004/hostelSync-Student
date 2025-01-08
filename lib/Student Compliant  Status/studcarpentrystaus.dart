import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // For formatting the timestamp

class CarpentryStatusPage extends StatefulWidget {
  const CarpentryStatusPage({super.key});

  @override
  _CarpentryStatusPageState createState() => _CarpentryStatusPageState();
}

class _CarpentryStatusPageState extends State<CarpentryStatusPage> {
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _getUserEmail();
  }

  void _getUserEmail() {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      userEmail = user?.email;
    });
  }

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('MMMM d, y h:mm a')
        .format(dateTime); // Format to desired pattern
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complaint Status'),
        backgroundColor: const Color(0xFF70D6FF),
      ),
      body: userEmail == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              color: const Color(0xFFCAF0F8),
              padding: const EdgeInsets.all(16.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('carpentry_status')
                    .where('email', isEqualTo: userEmail)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final complaints = snapshot.data!.docs;

                  if (complaints.isEmpty) {
                    return const Center(child: Text('No complaints found.'));
                  }

                  return ListView.builder(
                    itemCount: complaints.length,
                    itemBuilder: (context, index) {
                      var complaint = complaints[index];
                      String complaintText = complaint['complaint'];
                      String status = complaint['status'];
                      Timestamp timestamp = complaint['timestamp'];
                      String formattedTimestamp = formatTimestamp(timestamp);

                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          title: Text(complaintText),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Status: $status'),
                              Text('Date & Time: $formattedTimestamp'),
                            ],
                          ),
                          trailing: Icon(
                            status == 'Completed'
                                ? Icons.check_circle
                                : Icons.hourglass_bottom,
                            color: status == 'Completed'
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
    );
  }
}
