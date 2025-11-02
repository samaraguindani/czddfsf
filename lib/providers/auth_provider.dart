import 'package:flutter/material.dart';
import '../models/user.dart' as app_user;
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  app_user.User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  app_user.User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  AuthProvider() {
    _initializeAuth();
  }

  void _initializeAuth() {
    _authService.authStateChanges.listen((data) async {
      print('🔍 Auth state changed: ${data.event}');
      print('🔍 Session user ID: ${data.session?.user?.id}');
      
      if (data.session?.user != null) {
        print('✅ User authenticated, loading profile...');
        await _loadUserProfile(data.session!.user.id);
      } else {
        print('❌ No user session');
        _currentUser = null;
        notifyListeners();
      }
    });
  }

  Future<void> _loadUserProfile(String userId) async {
    try {
      print('📋 Loading user profile for: $userId');
      _currentUser = await _authService.getUserProfile(userId);
      
      if (_currentUser == null) {
        print('⚠️ User profile not found - trigger may not have executed');
        print('💡 User can still be authenticated, but profile needs to be created');
        // Usuário autenticado mas sem perfil - pode ser tratado posteriormente
      } else {
        print('✅ User profile loaded: ${_currentUser?.fullName}');
      }
      
      notifyListeners();
    } catch (e) {
      print('❌ Error loading user profile: $e');
      _errorMessage = 'Erro ao carregar perfil do usuário: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String cpf,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _authService.signUp(
        email: email,
        password: password,
        fullName: fullName,
        phone: phone,
        cpf: cpf,
      );

      if (response.user != null) {
        _setLoading(false);
        return true;
      } else {
        _setError('Erro ao criar conta');
        return false;
      }
    } catch (e) {
      _setError('Erro ao criar conta: ${e.toString()}');
      return false;
    }
  }

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    print('🚀 Starting sign in for: $email');
    _setLoading(true);
    _clearError();

    try {
      final response = await _authService.signIn(
        email: email,
        password: password,
      );

      print('🔍 Sign in response: ${response.user?.id}');
      print('🔍 Session: ${response.session?.user?.id}');

      if (response.user != null) {
        print('✅ Sign in successful');
        _setLoading(false);
        return true;
      } else {
        print('❌ Sign in failed - no user');
        _setError('Credenciais inválidas');
        return false;
      }
    } catch (e) {
      print('❌ Sign in error: $e');
      _setError('Erro ao fazer login: ${e.toString()}');
      return false;
    }
  }

  Future<void> signOut() async {
    _setLoading(true);
    try {
      await _authService.signOut();
      _currentUser = null;
      _setLoading(false);
    } catch (e) {
      _setError('Erro ao fazer logout');
    }
  }

  Future<void> deleteAccount() async {
    _setLoading(true);
    _clearError();
    
    try {
      await _authService.deleteAccount();
      _currentUser = null;
      _setLoading(false);
    } catch (e) {
      _setError('Erro ao excluir conta: ${e.toString()}');
      throw e;
    }
  }

  Future<void> resetPassword(String email) async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.resetPassword(email);
      _setLoading(false);
    } catch (e) {
      _setError('Erro ao enviar email de recuperação');
    }
  }

  Future<bool> updateProfile(app_user.User user) async {
    _setLoading(true);
    _clearError();

    try {
      _currentUser = await _authService.updateUserProfile(user);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Erro ao atualizar perfil');
      return false;
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    _isLoading = false;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
