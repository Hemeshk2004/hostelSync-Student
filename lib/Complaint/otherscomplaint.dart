import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import for Firebase Authentication
import 'package:flutter/services.dart'; // Import to use TextInputFormatter

class Otherscomplaint extends StatefulWidget {
  const Otherscomplaint({super.key});

  @override
  _OtherscomplaintState createState() => _OtherscomplaintState();
}

class _OtherscomplaintState extends State<Otherscomplaint> {
  final TextEditingController _roomNoController = TextEditingController();
  final TextEditingController _rollNoController = TextEditingController();
  final TextEditingController _complaintController = TextEditingController();

  final CollectionReference complaintsCollection = FirebaseFirestore.instance
      .collection('Otherscomplaints'); // Collection for complaints

  final CollectionReference downloadCollection = FirebaseFirestore.instance
      .collection('othersdownload'); // Collection for downloaded complaints

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
        // Retrieve user info from the 'appuser' collection using rollNo
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('appuser')
            .doc(rollNo)
            .get();

        if (userSnapshot.exists) {
          // Validate rollNo matches the user's email in the 'appuser' collection
          String registeredEmail = userSnapshot['email'];
          if (registeredEmail == email) {
            // Get the user's name from the 'appuser' collection
            String userName = userSnapshot['name'];

            // Add the complaint to the 'Otherscomplaints' collection
            await complaintsCollection.add({
              'roomNo': roomNo,
              'rollNo': rollNo,
              'complaint': complaint,
              'email': email,
              'name': userName,
              'timestamp': FieldValue.serverTimestamp(),
            });

            // Also add the complaint to the 'othersdownload' collection
            await downloadCollection.add({
              'roomNo': roomNo,
              'rollNo': rollNo,
              'complaint': complaint,
              'email': email,
              'name': userName,
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
            // If the rollNo does not match the email in the appuser collection
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Roll number does not match your email.')),
            );
          }
        } else {
          // If the rollNo is not found in the 'appuser' collection
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('User not found for the given roll number.')),
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
        color: const Color(0xFFCAF0F8), // Background color
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Row(),
            const SizedBox(height: 80),
            Image.asset(
              'assets/images/application.png',
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

            // rollNo field with uppercase input formatter
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
                UpperCaseTextFormatter(), // Capitalizes the roll number
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
                backgroundColor: const Color(0xFFC77DFF), // Button color
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                'Submit',
                style: TextStyle(
                  color: Colors.black, // Text color for button
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

// Custom TextInputFormatter to convert text to uppercase
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
