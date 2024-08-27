import 'package:flutter/material.dart';
import 'screens/login_page.dart';
import 'screens/registration_page.dart';
import 'screens/user_profile_page.dart';
import 'screens/home_page.dart';
import 'screens/job_provider_dashboard.dart';
import 'utils/posting_helper.dart';
import 'screens/create_job_posting_form.dart';

Future<void> main() async {

  runApp(const CareerBridgeApp());
}

class CareerBridgeApp extends StatelessWidget {
  const CareerBridgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CareerBridge',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Set the initial route if you want to show HomePage by default
      initialRoute: '/login',
      routes: {
        '/home': (context) => HomePage(isLoggedIn: true), // Replace with true if logged in
        '/login': (context) => LoginPage(),
        '/registration': (context) => RegistrationPage(),
        '/profile': (context) => UserProfilePage(email: 'gajera123@gmail.com'), // Pass the email if needed
        '/dashboard': (context) => JobProviderDashboard(),
         '/job_posting': (context)=> CreateJobPostingForm(),
      },
    );
  }
}

