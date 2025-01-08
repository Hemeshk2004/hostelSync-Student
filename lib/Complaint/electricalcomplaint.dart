import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class Electricalcomplaint extends StatefulWidget {
  const Electricalcomplaint({super.key});

  @override
  _ElectricalcomplaintState createState() => _ElectricalcomplaintState();
}

class _ElectricalcomplaintState extends State<Electricalcomplaint> {
  final TextEditingController _roomNoController = TextEditingController();
  final TextEditingController _rollNoController = TextEditingController();
  final TextEditingController _complaintController = TextEditingController();

  final CollectionReference complaintsCollection =
      FirebaseFirestore.instance.collection('electricalcomplaints');

  void _submitComplaint() async {
    String roomNo = _roomNoController.text.trim();
    String rollNo = _rollNoController.text.trim().toUpperCase();
    String complaint = _complaintController.text.trim();

    // Get the current user's email
    User? user = FirebaseAuth.instance.currentUser;
    String? email = user?.email;

    if (roomNo.isNotEmpty &&
        rollNo.isNotEmpty &&
        complaint.isNotEmpty &&
        email != null) {
      try {
        // Retrieve user data from the 'appuser' collection using rollNo
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('appuser')
            .doc(rollNo)
            .get();

        if (userSnapshot.exists) {
          // Check if the user's email matches the one in the appuser collection
          String userEmail = userSnapshot['email']; // Assuming 'email' exists
          if (email == userEmail) {
            // Add the complaint to the 'electricalcomplaints' collection
            await complaintsCollection.add({
              'roomNo': roomNo,
              'rollNo': rollNo,
              'complaint': complaint,
              'email': email, // Add email of the logged-in user
              'name': userSnapshot['name'], // Add user's name
              'timestamp': FieldValue.serverTimestamp(), // Submission time
            });

            // Add the same complaint to the 'electricaldownload' collection
            await FirebaseFirestore.instance
                .collection('electricaldownload')
                .add({
              'roomNo': roomNo,
              'rollNo': rollNo,
              'complaint': complaint,
              'email': email,
              'name': userSnapshot['name'],
              'timestamp': FieldValue.serverTimestamp(),
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
            // Email mismatch error
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Roll number does not match the logged-in user.'),
              ),
            );
          }
        } else {
          // Roll number not found in the 'appuser' collection
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User not found for the given roll number.'),
            ),
          );
        }
      } catch (e) {
        // Handle errors during Firestore operations
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit complaint: $e')),
        );
      }
    } else {
      // Show an error message if fields are empty or email is null
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Please fill out all fields and ensure you are logged in.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFCAF0F8), // Background color
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Row(),
            const SizedBox(height: 80),
            Image.asset(
              'assets/images/electrical.png',
              width: 71,
              height: 72,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 50),

            // Room No. field
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

            // Roll No field
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
              inputFormatters: [
                UpperCaseTextFormatter(), // Capitalize input text
              ],
            ),
            const SizedBox(height: 15),

            // Complaint field
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

            // Submit Button
            ElevatedButton(
              onPressed: _submitComplaint,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF07BEB8), // Button color
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                'Submit',
                style: TextStyle(
                  color: Colors.black, // Button text color
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

// Custom TextInputFormatter to capitalize input text
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: TextSelection.collapsed(offset: newValue.text.length),
    );
  }
}
