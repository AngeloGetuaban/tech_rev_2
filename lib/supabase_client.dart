import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseCredentials {
  static const String supabaseUrl = 'https://whpqtjnbxednqkolxfpg.supabase.co'; // Replace with your Supabase URL
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndocHF0am5ieGVkbnFrb2x4ZnBnIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTczNzI2NjkzNCwiZXhwIjoyMDUyODQyOTM0fQ.VJ5xv3dZXOZ1sl1UHuk6MqohDEbr-f68JdUyB14TCdg'; // Replace with your Supabase Anon Key
}

class SupabaseService {
  static Future<void> initializeSupabase() async {
    await Supabase.initialize(
      url: SupabaseCredentials.supabaseUrl,
      anonKey: SupabaseCredentials.supabaseAnonKey,
    );
  }
}
