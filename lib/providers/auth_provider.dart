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
      if (data.session?.user != null) {
        await _loadUserProfile(data.session!.user.id);
      } else {
        _currentUser = null;
        notifyListeners();
      }
    });
  }

  Future<void> _loadUserProfile(String userId) async {
    try {
      _currentUser = await _authService.getUserProfile(userId);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Erro ao carregar perfil do usuário';
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
    _setLoading(true);
    _clearError();

    try {
      final response = await _authService.signIn(
        email: email,
        password: password,
      );

      if (response.user != null) {
        _setLoading(false);
        return true;
      } else {
        _setError('Credenciais inválidas');
        return false;
      }
    } catch (e) {
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
