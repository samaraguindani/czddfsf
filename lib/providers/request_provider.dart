import 'package:flutter/material.dart';
import '../models/request.dart';
import '../models/enums.dart';
import '../services/request_service.dart';

class RequestProvider extends ChangeNotifier {
  final RequestService _requestService = RequestService();
  
  List<Request> _requests = [];
  List<Request> _myRequests = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Request> get requests => _requests;
  List<Request> get myRequests => _myRequests;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadAllRequests() async {
    _setLoading(true);
    _clearError();

    try {
      _requests = await _requestService.getAllRequests();
      _setLoading(false);
    } catch (e) {
      _setError('Erro ao carregar pedidos');
    }
  }

  Future<void> loadMyRequests(String userId) async {
    _setLoading(true);
    _clearError();

    try {
      _myRequests = await _requestService.getRequestsByUser(userId);
      _setLoading(false);
    } catch (e) {
      _setError('Erro ao carregar meus pedidos');
    }
  }

  Future<List<Request>> searchRequests({
    String? query,
    ServiceCategory? category,
    PricingType? pricingType,
    String? city,
    String? state,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final results = await _requestService.searchRequests(
        query: query,
        category: category,
        pricingType: pricingType,
        city: city,
        state: state,
      );
      _setLoading(false);
      return results;
    } catch (e) {
      _setError('Erro ao buscar pedidos');
      return [];
    }
  }

  Future<bool> createRequest(Request request) async {
    _setLoading(true);
    _clearError();

    try {
      await _requestService.createRequest(request);
      await loadMyRequests(request.userId);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Erro ao criar pedido');
      return false;
    }
  }

  Future<bool> updateRequest(Request request) async {
    _setLoading(true);
    _clearError();

    try {
      await _requestService.updateRequest(request);
      await loadMyRequests(request.userId);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Erro ao atualizar pedido');
      return false;
    }
  }

  Future<bool> deleteRequest(String requestId, String userId) async {
    _setLoading(true);
    _clearError();

    try {
      await _requestService.deleteRequest(requestId);
      await loadMyRequests(userId);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Erro ao excluir pedido');
      return false;
    }
  }

  Future<Request?> getRequestById(String requestId) async {
    try {
      return await _requestService.getRequestById(requestId);
    } catch (e) {
      _setError('Erro ao carregar pedido');
      return null;
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
