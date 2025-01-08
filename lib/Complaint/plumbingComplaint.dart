import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import for Firebase Authentication
import 'package:flutter/services.dart'; // Import to use TextInputFormatter

class Plumbingcomplaint extends StatefulWidget {
  const Plumbingcomplaint({super.key});

  @override
  _PlumbingcomplaintState createState() => _PlumbingcomplaintState();
}

class _PlumbingcomplaintState extends State<Plumbingcomplaint> {
  final TextEditingController _roomNoController = TextEditingController();
  final TextEditingController _rollNoController = TextEditingController();
  final TextEditingController _complaintController = TextEditingController();

  final CollectionReference complaintsCollection =
      FirebaseFirestore.instance.collection('plumbingcomplaints');

  void _submitComplaint() async {
    String roomNo = _roomNoController.text.trim();
    String rollNo =
        _rollNoController.text.trim().toUpperCase(); // Ensure uppercase
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
          // Check if the email matches the rollNo
          String registeredEmail =
              userSnapshot['email']; // Ensure the 'email' field exists
          if (registeredEmail == email) {
            String userName = userSnapshot['name']; // Get the user's name

            // Add the complaint to the 'plumbingcomplaints' collection
            await complaintsCollection.add({
              'roomNo': roomNo,
              'rollNo': rollNo,
              'complaint': complaint,
              'email': email, // Add email of the logged-in user
              'name': userName, // Add user's name
              'timestamp': FieldValue.serverTimestamp(),
            });

            // Also add the complaint to the 'plumbingdownload' collection
            await FirebaseFirestore.instance
                .collection('plumbingdownload')
                .add({
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
            // If the email does not match the rollNo
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Roll No does not match your email.')),
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
              'assets/images/plumbing.png',
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

            // Roll No. field
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
                UpperCaseTextFormatter(), // Custom formatter to convert text to uppercase
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
                backgroundColor: const Color(0xFFFF8FAB), // Button color
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
