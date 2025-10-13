import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user.dart' as app_user;

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  User? get currentUser => _supabase.auth.currentUser;

  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String cpf,
  }) async {
    // Usar apenas o supabase.auth.signUp() - o trigger criará automaticamente o perfil na tabela users
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {
        'full_name': fullName,
        'phone': phone,
        'cpf': cpf,
      },
    );

    // O trigger handle_new_user() criará automaticamente o registro na tabela users
    // Não precisamos mais inserir manualmente aqui
    
    return response;
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _supabase.auth.resetPasswordForEmail(email);
  }

  Future<app_user.User?> getUserProfile(String userId) async {
    final response = await _supabase
        .from('users')
        .select()
        .eq('id', userId)
        .single();

    return app_user.User.fromJson(response);
  }

  Future<app_user.User> updateUserProfile(app_user.User user) async {
    final response = await _supabase
        .from('users')
        .update(user.toJson())
        .eq('id', user.id)
        .select()
        .single();

    return app_user.User.fromJson(response);
  }
}