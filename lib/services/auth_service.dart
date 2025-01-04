import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ocr_app/models/user_data.dart';
import 'package:ocr_app/Holders/data_holder.dart';

class AuthService {
  static const String baseUrl = 'http://10.0.2.2:5001/api'; // For Android Simu.
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
      final responseData = json.decode(response.body);

      // Set current user in DataHolder
      DataHolder.currentUser = UserData(
        userId: responseData['user_id'],
        username: responseData['username'],
        phoneNumber: responseData['phone_number'],
      );

      return responseData;
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
      final responseData = json.decode(response.body);

      // Set current user in DataHolder
      DataHolder.currentUser = UserData(
        userId: responseData['user_id'],
        username: responseData['username'],
        phoneNumber: responseData['phone_number'],
      );
      print(DataHolder());
      return responseData;
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
