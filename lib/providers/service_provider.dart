import 'package:flutter/material.dart';
import '../models/service.dart';
import '../models/enums.dart';
import '../services/service_service.dart';

class ServiceProvider extends ChangeNotifier {
  final ServiceService _serviceService = ServiceService();
  
  List<Service> _services = [];
  List<Service> _myServices = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Service> get services => _services;
  List<Service> get myServices => _myServices;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadAllServices() async {
    _setLoading(true);
    _clearError();

    try {
      _services = await _serviceService.getAllServices();
      _setLoading(false);
    } catch (e) {
      _setError('Erro ao carregar serviços');
    }
  }

  Future<void> loadMyServices(String userId) async {
    _setLoading(true);
    _clearError();

    try {
      _myServices = await _serviceService.getServicesByUser(userId);
      _setLoading(false);
    } catch (e) {
      _setError('Erro ao carregar meus serviços');
    }
  }

  Future<List<Service>> searchServices({
    String? query,
    ServiceCategory? category,
    PricingType? pricingType,
    String? city,
    String? state,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final results = await _serviceService.searchServices(
        query: query,
        category: category,
        pricingType: pricingType,
        city: city,
        state: state,
      );
      _setLoading(false);
      return results;
    } catch (e) {
      _setError('Erro ao buscar serviços');
      return [];
    }
  }

  Future<bool> createService(Service service) async {
    _setLoading(true);
    _clearError();

    try {
      await _serviceService.createService(service);
      await loadMyServices(service.userId);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Erro ao criar serviço');
      return false;
    }
  }

  Future<bool> updateService(Service service) async {
    _setLoading(true);
    _clearError();

    try {
      await _serviceService.updateService(service);
      await loadMyServices(service.userId);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Erro ao atualizar serviço');
      return false;
    }
  }

  Future<bool> deleteService(String serviceId, String userId) async {
    _setLoading(true);
    _clearError();

    try {
      await _serviceService.deleteService(serviceId);
      await loadMyServices(userId);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Erro ao excluir serviço');
      return false;
    }
  }

  Future<Service?> getServiceById(String serviceId) async {
    try {
      return await _serviceService.getServiceById(serviceId);
    } catch (e) {
      _setError('Erro ao carregar serviço');
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
