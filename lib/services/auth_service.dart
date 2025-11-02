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
    // Fazer o sign up no Supabase Auth
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {
        'full_name': fullName,
        'phone': phone,
        'cpf': cpf,
      },
    );

    // Criar manualmente o registro na tabela users para garantir que o perfil exista
    if (response.user != null) {
      try {
        // Verificar se o usuário já existe
        final existingUser = await _supabase
            .from('users')
            .select()
            .eq('id', response.user!.id)
            .maybeSingle();

        // Se não existir, criar
        if (existingUser == null) {
          await _supabase.from('users').insert({
            'id': response.user!.id,
            'email': email,
            'full_name': fullName,
            'phone': phone,
            'cpf': cpf,
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          });
          print('✅ User profile created successfully in users table');
        } else {
          print('ℹ️ User profile already exists in users table');
        }
      } catch (e) {
        print('⚠️ Error creating user profile in users table: $e');
        // Não falhar o sign up mesmo se houver erro ao criar o perfil
        // O trigger pode ter criado, ou será criado depois
      }
    }
    
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
    try {
      // Tentar buscar o perfil na tabela users
      final response = await _supabase
          .from('users')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response == null) {
        print('! User profile not found in database for ID: $userId');
        return null;
      }

      print('✅ User profile loaded: ${response['full_name']}');
      return app_user.User.fromJson(response);
    } catch (e) {
      print('❌ Error fetching user profile: $e');
      rethrow;
    }
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