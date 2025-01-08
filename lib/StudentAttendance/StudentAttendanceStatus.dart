import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StudentAttendanceStatusPage extends StatefulWidget {
  const StudentAttendanceStatusPage({super.key});

  @override
  _StudentAttendanceStatusPageState createState() =>
      _StudentAttendanceStatusPageState();
}

class _StudentAttendanceStatusPageState
    extends State<StudentAttendanceStatusPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String _email;
  List<Map<String, dynamic>> _attendanceRecords = [];

  @override
  void initState() {
    super.initState();
    _fetchEmailAndAttendanceStatus();
  }

  Future<void> _fetchEmailAndAttendanceStatus() async {
    // Retrieve the current user
    User? user = _auth.currentUser;

    if (user != null) {
      _email = user.email!;

      // List of dates for which we want to retrieve attendance (can be dynamic)
      List<DateTime> dates = [
        DateTime.now(),
        DateTime.now().subtract(const Duration(days: 1)),
        DateTime.now().subtract(const Duration(days: 2)),
        // Add more dates as needed
      ];

      List<Map<String, dynamic>> allRecords = [];

      try {
        // Loop through each date and fetch attendance records
        for (DateTime date in dates) {
          String formattedDate = DateFormat('yyyyMMdd').format(date);
          String collectionName = 'Attendance$formattedDate';

          QuerySnapshot snapshot =
              await _firestore.collection(collectionName).get();

          // Add the fetched records to the list if the email matches
          allRecords.addAll(
            snapshot.docs
                .map((doc) => doc.data() as Map<String, dynamic>)
                .where((data) => data['email'] == _email)
                .toList(),
          );
        }

        // Ensure the widget is still mounted before calling setState
        if (mounted) {
          setState(() {
            _attendanceRecords = allRecords;
          });
        }
      } catch (e) {
        print('Error fetching attendance data: $e');
      }
    } else {
      print("User not logged in");
    }
  }

  // Helper function to format the date with spaces
  String _formatDate(String date) {
    if (date == 'Unknown') return date;

    // Assuming the date is in 'yyyyMMdd' format
    if (date.length == 8) {
      String year = date.substring(0, 4);
      String month = date.substring(4, 6);
      String day = date.substring(6, 8);
      return '$year $month $day';
    }

    return date; // Return the date unmodified if it's not in the expected format
  }

  @override
  void dispose() {
    // Perform any cleanup if needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCAF0F8),
      appBar: AppBar(
        title: const Text(
          'Attendance Status',
          style: TextStyle(fontSize: 24),
        ),
        backgroundColor: const Color(0xFFCAF0F8),
      ),
      body: ListView.builder(
        itemCount: _attendanceRecords.length,
        itemBuilder: (context, index) {
          final record = _attendanceRecords[index];
          return ListTile(
            title: Text(record['name'] ?? 'Unknown'),
            subtitle: Text('Date: ${_formatDate(record['date'] ?? 'Unknown')}'),
            trailing: CircleAvatar(
              backgroundColor:
                  record['attendance'] == "Present" ? Colors.green : Colors.red,
              radius: 10,
            ),
          );
        },
      ),
    );
  }
}
