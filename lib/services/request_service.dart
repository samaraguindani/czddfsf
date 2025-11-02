import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/request.dart';
import '../models/enums.dart';

class RequestService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Request>> getAllRequests() async {
    final response = await _supabase
        .from('requests')
        .select()
        .order('created_at', ascending: false);

    final requests = (response as List)
        .map((json) => Request.fromJson(json))
        .toList();
    
    // Ordenar por urgência: urgente > médio > baixo, e depois por data
    requests.sort((a, b) {
      final urgencyA = _getUrgencyPriority(a.urgency);
      final urgencyB = _getUrgencyPriority(b.urgency);
      
      // Se as urgências são diferentes, ordenar por urgência
      if (urgencyA != urgencyB) {
        return urgencyA.compareTo(urgencyB);
      }
      
      // Se as urgências são iguais, ordenar por data (mais recente primeiro)
      return b.createdAt.compareTo(a.createdAt);
    });
    
    return requests;
  }

  Future<List<Request>> getRequestsByUser(String userId) async {
    final response = await _supabase
        .from('requests')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => Request.fromJson(json))
        .toList();
  }

  Future<List<Request>> searchRequests({
    String? query,
    ServiceCategory? category,
    PricingType? pricingType,
    String? city,
    String? state,
  }) async {
    var queryBuilder = _supabase.from('requests').select();

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

    final requests = (response as List)
        .map((json) => Request.fromJson(json))
        .toList();
    
    // Ordenar por urgência: urgente > médio > baixo, e depois por data
    requests.sort((a, b) {
      final urgencyA = _getUrgencyPriority(a.urgency);
      final urgencyB = _getUrgencyPriority(b.urgency);
      
      // Se as urgências são diferentes, ordenar por urgência
      if (urgencyA != urgencyB) {
        return urgencyA.compareTo(urgencyB);
      }
      
      // Se as urgências são iguais, ordenar por data (mais recente primeiro)
      return b.createdAt.compareTo(a.createdAt);
    });
    
    return requests;
  }
  
  int _getUrgencyPriority(String urgency) {
    switch (urgency.toLowerCase()) {
      case 'urgente':
        return 1;
      case 'médio':
        return 2;
      case 'baixo':
        return 3;
      default:
        return 4;
    }
  }

  Future<Request> createRequest(Request request) async {
    print('🔄 Inserting request into database...');
    final requestData = request.toJson(forInsert: true);
    print('📋 Request data: $requestData');
    
    try {
      final response = await _supabase
          .from('requests')
          .insert(requestData)
          .select()
          .single();

      print('✅ Database insert successful');
      return Request.fromJson(response);
    } catch (e) {
      print('❌ Database insert failed: $e');
      rethrow;
    }
  }

  Future<Request> updateRequest(Request request) async {
    final response = await _supabase
        .from('requests')
        .update(request.toJson())
        .eq('id', request.id)
        .select()
        .single();

    return Request.fromJson(response);
  }

  Future<void> deleteRequest(String requestId) async {
    await _supabase.from('requests').delete().eq('id', requestId);
  }

  Future<Request?> getRequestById(String requestId) async {
    try {
      final response = await _supabase
          .from('requests')
          .select()
          .eq('id', requestId)
          .single();

      return Request.fromJson(response);
    } catch (e) {
      return null;
    }
  }
}
