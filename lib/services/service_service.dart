import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/service.dart';
import '../models/enums.dart';

class ServiceService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Service>> getAllServices() async {
    final response = await _supabase
        .from('services')
        .select()
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => Service.fromJson(json))
        .toList();
  }

  Future<List<Service>> getServicesByUser(String userId) async {
    final response = await _supabase
        .from('services')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => Service.fromJson(json))
        .toList();
  }

  Future<List<Service>> searchServices({
    String? query,
    ServiceCategory? category,
    PricingType? pricingType,
    String? city,
    String? state,
  }) async {
    var queryBuilder = _supabase.from('services').select();

    if (query != null && query.isNotEmpty) {
      queryBuilder = queryBuilder.or('title.ilike.%$query%,description.ilike.%$query%');
    }

    if (category != null) {
      queryBuilder = queryBuilder.eq('category', category.name);
    }

    if (pricingType != null) {
      queryBuilder = queryBuilder.eq('pricing_type', pricingType.name);
    }

    if (city != null && city.isNotEmpty) {
      queryBuilder = queryBuilder.eq('city', city);
    }

    if (state != null && state.isNotEmpty) {
      queryBuilder = queryBuilder.eq('state', state);
    }

    final response = await queryBuilder.order('created_at', ascending: false);

    return (response as List)
        .map((json) => Service.fromJson(json))
        .toList();
  }

  Future<Service> createService(Service service) async {
    final response = await _supabase
        .from('services')
        .insert(service.toJson(forInsert: true))
        .select()
        .single();

    return Service.fromJson(response);
  }

  Future<Service> updateService(Service service) async {
    final response = await _supabase
        .from('services')
        .update(service.toJson())
        .eq('id', service.id)
        .select()
        .single();

    return Service.fromJson(response);
  }

  Future<void> deleteService(String serviceId) async {
    await _supabase.from('services').delete().eq('id', serviceId);
  }

  Future<Service?> getServiceById(String serviceId) async {
    try {
      final response = await _supabase
          .from('services')
          .select()
          .eq('id', serviceId)
          .single();

      return Service.fromJson(response);
    } catch (e) {
      return null;
    }
  }
}
