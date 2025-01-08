import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:hostelsync/Complaint/carpentrycomplaint.dart';
import 'package:hostelsync/Complaint/electricalcomplaint.dart';
import 'package:hostelsync/Login%20Signup/Screen/login.dart';
import 'package:hostelsync/Student%20Compliant%20%20Status/studcarpentrystaus.dart';
import 'package:hostelsync/Student%20Compliant%20%20Status/studelectricalstatus.dart';
import 'package:hostelsync/Student%20Compliant%20%20Status/studplumbingstaus.dart';
import 'package:hostelsync/Student%20Compliant%20%20Status/stuothersstatus.dart';
import 'package:hostelsync/complaintscreen.dart';
import 'package:hostelsync/home_page_2.dart';
import 'Chat App/chat_page.dart';
import 'package:hostelsync/othersScreen.dart';
import 'Complaint/plumbingComplaint.dart';
import 'package:hostelsync/Complaint/otherscomplaint.dart';
import 'package:hostelsync/StudentAttendance/StudentAttendanceStatus.dart';
import 'Student Compliant  Status/complaintStatusScreen.dart';
import 'firebase_options.dart'; // Import Firebase options for platform-specific configurations

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure proper initialization
  await Firebase.initializeApp(
    options:
        DefaultFirebaseOptions.currentPlatform, // Use platform-specific options
  );
  runApp(const MyApp()); // Start the app
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hostel Management App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const AuthWrapper(), // Home screen is AuthWrapper
      routes: {
        'Attendance': (context) => const StudentAttendanceStatusPage(),
        'Complaints': (context) => const CompliantScreen(),
        'Notices': (context) => const ChatPage(),
        'Others': (context) => OthersScreenPage(),
        '/attendance': (context) => const StudentAttendanceStatusPage(),
        'Electrical': (context) => const Electricalcomplaint(),
        'Plumbing': (context) => const Plumbingcomplaint(),
        'Carpentry': (context) => const Carpentrycomplaint(),
        'Otherscom': (context) => const Otherscomplaint(),
        'StatusPage': (context) => const CompliantStatusScreen(),
        'ElectricalStatus': (context) => const ElectricalStatusPage(),
        'PlumbingStatus': (context) => const PlumbingStatusPage(),
        'CarpentryStatus': (context) => const CarpentryStatusPage(),
        'OtherscomStatus': (context) => const OthersStatusPage(),
        // Add other routes here if needed
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Listen to the authentication state
    return StreamBuilder<User?>(
      // Check auth state
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            return const HomePage2Widget(); // If signed in, show home page
          } else {
            return const LoginScreen(); // Show login screen if not signed in
          }
        } else {
          return const Scaffold(
            body:
                Center(child: CircularProgressIndicator()), // Loading indicator
          );
        }
      },
    );
  }
}
