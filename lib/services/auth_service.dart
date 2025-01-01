import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://10.0.2.2:5001/api';  // For Android Simu.
  // static const String baseUrl = 'http://localhost:5001/api'; // For all others

  // Method for Sign Up
  Future<Map<String, dynamic>> signUp(
      String username, String fullName, String phoneNumber, String password) async {
    final url = Uri.parse('$baseUrl/users/signup');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'full_name': fullName,
        'phone_number': phoneNumber,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create user: ${response.body}');
    }
  }

  // Method for Login
  Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/users/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // Decode the response and add the status field
      var responseBody = json.decode(response.body);
      responseBody['status'] = 'success'; // Add status manually
      return responseBody;
    } else if (response.statusCode == 401) {
      return {
        'status': 'error',
        'message': 'Invalid username or password.',
      };
    } else {
      return {
        'status': 'error',
        'message': 'Login failed: ${response.body}',
      };
    }
  }

}
