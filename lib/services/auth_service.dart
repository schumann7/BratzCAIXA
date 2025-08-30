import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // Tornando a URL estática também para consistência
  static final String _apiUrl = 'http://localhost:5000/bratz/auth/login';

  // --- Dados do Usuário Logado (acessíveis globalmente) ---
  static String? token;
  static String? email;
  static String? accountType;
  static Map<String, dynamic>? privileges;
  static Map<String, dynamic>? profile;

  // --- MÉTODOS ESTÁTICOS ---
  static Future<void> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(_apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      
      // Armazena os dados nas variáveis estáticas
      AuthService.token = data['token'] as String?;
      AuthService.email = data['email'] as String?;
      AuthService.accountType = data['account_type'] as String?;
      AuthService.privileges = data['privileges'] as Map<String, dynamic>?;
      AuthService.profile = data['profile'] as Map<String, dynamic>?;

    } else {
      final errorResponse = json.decode(response.body);
      throw Exception(errorResponse['message']);
    }
  }

  static void logout() {
    // Limpa os dados ao deslogar
    AuthService.token = null;
    AuthService.email = null;
    AuthService.accountType = null;
    AuthService.privileges = null;
    AuthService.profile = null;
  }
}