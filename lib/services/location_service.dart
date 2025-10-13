import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/location.dart';

class LocationService {
  static const String _baseUrl = 'https://servicodados.ibge.gov.br/api/v1/localidades';

  Future<List<Estado>> getStates() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/estados'));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Estado.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao carregar estados');
      }
    } catch (e) {
      throw Exception('Erro ao buscar estados: $e');
    }
  }

  Future<List<City>> getCitiesByState(int stateId) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/estados/$stateId/municipios'));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => City.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao carregar cidades');
      }
    } catch (e) {
      throw Exception('Erro ao buscar cidades: $e');
    }
  }

  Future<List<City>> getCitiesByStateCode(String stateCode) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/estados/$stateCode/municipios'));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => City.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao carregar cidades');
      }
    } catch (e) {
      throw Exception('Erro ao buscar cidades: $e');
    }
  }
}
