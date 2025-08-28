import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String _apiUrl = 'http://localhost:5000/bratz/auth/login';

  Future<Map<String, dynamic>> login(String email, String password) async {
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
      return json.decode(response.body)['data'];
    } else {
      final errorResponse = json.decode(response.body);
      throw Exception(errorResponse['message']);
    }
  }
}