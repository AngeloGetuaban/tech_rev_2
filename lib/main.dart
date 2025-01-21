import 'package:flutter/material.dart';
import 'package:tech_rev/screens/welcome_page.dart';
import 'supabase_client.dart'; // Import your Supabase client

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await SupabaseService.initializeSupabase();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tech Rev',
      home: const WelcomePage(),
    );
  }
}
