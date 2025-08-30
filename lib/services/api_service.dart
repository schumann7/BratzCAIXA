import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bratzcaixa/services/auth_service.dart';

class ApiService {
  final String _baseUrl = 'http://localhost:5000/bratz';

  // --- Funções de Venda ---
  Future<void> registerSell(Map<String, dynamic> sellData) async {
    final token = AuthService.token;
    if (token == null) {
      throw Exception('Usuário não autenticado. Realize o login novamente.');
    }
    final response = await http.post(
      Uri.parse('$_baseUrl/finances/register-sell'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(sellData),
    );
    if (response.statusCode != 201) {
      final errorResponse = json.decode(response.body);
      throw Exception('Falha ao registrar venda: ${errorResponse['message']}');
    }
  }

  // --- Funções de Cliente ---
  Future<List<dynamic>> fetchClients({String? searchQuery}) async {
    final token = AuthService.token;
    if (token == null) throw Exception('Usuário não autenticado.');
    final Uri url;
    if (searchQuery != null && searchQuery.isNotEmpty) {
      url = Uri.parse('$_baseUrl/clients?q=$searchQuery');
    } else {
      url = Uri.parse('$_baseUrl/clients');
    }
    final response = await http.get(url, headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      return json.decode(response.body)['data']['clients'];
    } else {
      throw Exception('Falha ao carregar clientes');
    }
  }

  Future<void> createClient(Map<String, dynamic> clientData) async {
    final token = AuthService.token;
    if (token == null) throw Exception('Usuário não autenticado.');
    final response = await http.post(
      Uri.parse('$_baseUrl/clients'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(clientData),
    );
    if (response.statusCode != 201) {
      final errorResponse = json.decode(response.body);
      throw Exception('Erro ao criar cliente: ${errorResponse['message']}');
    }
  }

  Future<void> deleteClient(int clientId) async {
    final token = AuthService.token;
    if (token == null) throw Exception('Usuário não autenticado.');
    final response = await http.delete(
      Uri.parse('$_baseUrl/clients/$clientId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 200) {
      final errorResponse = json.decode(response.body);
      throw Exception('Erro ao remover cliente: ${errorResponse['message']}');
    }
  }

  // --- Funções de Produto ---
  Future<List<dynamic>> fetchProducts({String? searchQuery}) async {
    final token = AuthService.token;
    if (token == null) throw Exception('Usuário não autenticado.');
    final Map<String, String> queryParams = {};
    if (searchQuery != null && searchQuery.isNotEmpty) {
      queryParams['item'] = searchQuery;
    }
    final url = Uri.http('localhost:5000', '/bratz/products', queryParams);
    final response = await http.get(url, headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      return json.decode(response.body)['data']['products'];
    } else {
      throw Exception('Falha ao carregar produtos');
    }
  }
  
  // --- MÉTODO QUE ESTAVA FALTANDO ---
  Future<Map<String, dynamic>> fetchProductById(String id) async {
    final token = AuthService.token;
    if (token == null) throw Exception('Usuário não autenticado.');

    final response = await http.get(
      Uri.parse('$_baseUrl/products/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    } else {
      throw Exception('Produto com ID "$id" não encontrado.');
    }
  }

  Future<void> createProduct(Map<String, dynamic> productData) async {
    final token = AuthService.token;
    if (token == null) throw Exception('Usuário não autenticado.');

    final response = await http.post(
      Uri.parse('$_baseUrl/products'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(productData),
    );

    if (response.statusCode != 201) {
      final errorResponse = json.decode(response.body);
      throw Exception('Erro ao criar produto: ${errorResponse['message']}');
    }
  }

  Future<void> deleteProduct(int productId) async {
    final token = AuthService.token;
    if (token == null) throw Exception('Usuário não autenticado.');

    final response = await http.delete(
      Uri.parse('$_baseUrl/products/$productId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      final errorResponse = json.decode(response.body);
      throw Exception('Erro ao remover produto: ${errorResponse['message']}');
    }
  }
}