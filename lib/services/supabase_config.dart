import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  // IMPORTANTE: Substitua estas URLs pelas suas credenciais do Supabase
  static const String url = 'https://raixvpetjipdqxpfpwuw.supabase.co';
  static const String anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJhaXh2cGV0amlwZHF4cGZwd3V3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjAzNzY5OTIsImV4cCI6MjA3NTk1Mjk5Mn0.3Rn23mzvadDq0Y_eidSpHHmncgDodzTjzYNbb1RQgkk';
  
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
    );
  }
  
  static SupabaseClient get client => Supabase.instance.client;
}
