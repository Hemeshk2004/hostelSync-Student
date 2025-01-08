import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // For Firebase Authentication
import 'package:intl/intl.dart'; // For formatting the timestamp

class PlumbingStatusPage extends StatefulWidget {
  const PlumbingStatusPage({super.key});

  @override
  _PlumbingStatusPageState createState() => _PlumbingStatusPageState();
}

class _PlumbingStatusPageState extends State<PlumbingStatusPage> {
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _getUserEmail(); // Fetch the user's email when the page is initialized
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
        backgroundColor: const Color(0xFFFF8FAB),
      ),
      body: userEmail == null
          ? const Center(
              child: CircularProgressIndicator(),
            ) // Show a loader while fetching email
          : Container(
              color: const Color(0xFFCAF0F8),
              padding: const EdgeInsets.all(16.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('plumbing_status')
                    .where('email',
                        isEqualTo: userEmail) // Query by user's email
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
