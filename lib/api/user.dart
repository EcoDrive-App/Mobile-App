import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../utils/token_storage.dart';

class UserApi {
  static final String baseUrl = dotenv.env['API_URL'] ?? '';

  static Future<void> updateUser(String id, String? name, String? email,String? password,) async {
    final token = await TokenStorage.getToken();

    final Map<String, dynamic> body = {};
    if (name != null) body['name'] = name;
    if (email != null) body['email'] = email;
    if (password != null) body['password'] = password;

    await http.put(
      Uri.parse('$baseUrl/user/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(body),
    );
  }
}