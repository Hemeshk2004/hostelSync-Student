import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Carpentrycomplaint extends StatefulWidget {
  const Carpentrycomplaint({super.key});

  @override
  _CarpentrycomplaintState createState() => _CarpentrycomplaintState();
}

class _CarpentrycomplaintState extends State<Carpentrycomplaint> {
  final TextEditingController _roomNoController = TextEditingController();
  final TextEditingController _rollNoController = TextEditingController();
  final TextEditingController _complaintController = TextEditingController();

  final CollectionReference complaintsCollection =
      FirebaseFirestore.instance.collection('carpentrycomplaints');
  final CollectionReference carpentryDownloadCollection =
      FirebaseFirestore.instance.collection('carpentrydownload');
  final CollectionReference appUserCollection =
      FirebaseFirestore.instance.collection('appuser');

  void _submitComplaint() async {
    String roomNo = _roomNoController.text.trim();
    String rollNo =
        _rollNoController.text.trim().toUpperCase(); // Capitalize rollNo
    String complaint = _complaintController.text.trim();

    // Get the current user's email
    User? user = FirebaseAuth.instance.currentUser;
    String? email = user?.email;

    if (roomNo.isNotEmpty &&
        rollNo.isNotEmpty &&
        complaint.isNotEmpty &&
        email != null) {
      try {
        // Retrieve the user's record from the appuser collection using rollNo
        DocumentSnapshot appUserSnapshot =
            await appUserCollection.doc(rollNo).get();

        if (appUserSnapshot.exists) {
          String userEmail = appUserSnapshot['email']; // Assuming 'email' field
          String name = appUserSnapshot['name']; // Assuming 'name' field exists

          // Check if the input rollNo matches the logged-in user's email
          if (userEmail == email) {
            // Add the complaint to the carpentrycomplaints collection
            DocumentReference complaintRef = await complaintsCollection.add({
              'roomNo': roomNo,
              'rollNo': rollNo,
              'name': name,
              'complaint': complaint,
              'email': email,
              'timestamp': FieldValue.serverTimestamp(),
            });

            // Add the same complaint to the carpentrydownload collection
            await carpentryDownloadCollection.add({
              'roomNo': roomNo,
              'rollNo': rollNo,
              'name': name,
              'complaint': complaint,
              'email': email,
              'timestamp': FieldValue.serverTimestamp(),
              'originalComplaintId': complaintRef.id, // Optional for tracking
            });

            // Clear the text fields
            _roomNoController.clear();
            _rollNoController.clear();
            _complaintController.clear();

            // Show a success message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Complaint submitted successfully!')),
            );
          } else {
            // If the rollNo doesn't match the logged-in user's email
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Roll No does not match your email!')),
            );
          }
        } else {
          // If no user is found for the provided rollNo
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('No user found for the provided Roll No.')),
          );
        }
      } catch (e) {
        // Handle error if adding fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit complaint: $e')),
        );
      }
    } else {
      // Show an error message if fields are empty or email is null
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Please fill out all fields and ensure you are logged in.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFCAF0F8),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Row(),
            const SizedBox(height: 80),
            Image.asset(
              'assets/images/Carpentry.png',
              width: 71,
              height: 72,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 50),
            TextField(
              controller: _roomNoController,
              decoration: InputDecoration(
                labelText: 'Room No',
                labelStyle: const TextStyle(color: Colors.black),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _rollNoController,
              decoration: InputDecoration(
                labelText: 'Roll No',
                labelStyle: const TextStyle(color: Colors.black),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _complaintController,
              decoration: InputDecoration(
                labelText: 'Complaint',
                labelStyle: const TextStyle(color: Colors.black),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _submitComplaint,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF70D6FF),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                'Submit',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _roomNoController.dispose();
    _rollNoController.dispose();
    _complaintController.dispose();
    super.dispose();
  }
}
