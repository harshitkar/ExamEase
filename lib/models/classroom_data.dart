import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Holders/data_holder.dart';

class ClassroomData {
  static const String baseUrl = 'http://10.0.2.2:5001/api'; // For Android Emulator

  int? classroomId; // Changed to int for sequential ID
  String classroomName;
  DateTime? createdAt;
  String classroomCode; // Added classroomCode

  ClassroomData({
    this.classroomId,
    this.classroomName = '',
    this.createdAt,
    this.classroomCode = '', // Default value for classroomCode
  });

  Map<String, dynamic> toJson() {
    return {
      'classroomId': classroomId,
      'classroomName': classroomName,
      'createdAt': createdAt?.toIso8601String(),
      'classroomCode': classroomCode, // Include classroomCode in toJson
    };
  }

  factory ClassroomData.fromJson(Map<String, dynamic> json) {
    return ClassroomData(
      classroomId: json['classroomId'],
      classroomName: json['classroomName'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      classroomCode: json['classroomCode'] ?? '', // Default to empty string if null
    );
  }

  /// Save classroom to backend with sequential ID and classroomCode
  Future<void> saveClassroom() async {
    final url = Uri.parse('$baseUrl/classrooms/create');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'classroomName': classroomName,
          'createdBy': DataHolder.currentUser?.userId ?? 0, // Ensure createdBy is numeric
          'classroomCode': classroomCode, // Send classroomCode to the backend
        }),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        classroomId = responseData['classroomId'];
        createdAt = responseData['createdAt'] != null ? DateTime.parse(responseData['createdAt']) : null;
        classroomCode = responseData['classroomCode'] ?? ''; // Receive classroomCode from response
      } else {
        throw Exception('Failed to create classroom: ${response.body}');
      }
    } catch (e) {
      throw Exception('An error occurred while saving the classroom: $e');
    }
  }

  /// Load classroom by ID from backend
  static Future<ClassroomData?> loadClassroomData(int classroomId) async {
    final url = Uri.parse('$baseUrl/classrooms/$classroomId');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return ClassroomData.fromJson(responseData);
      } else {
        throw Exception('Failed to load classroom: ${response.body}');
      }
    } catch (e) {
      throw Exception('An error occurred while loading the classroom: $e');
    }
  }

  /// Join classroom via backend
  Future<void> joinClassroom(String role) async {
    final url = Uri.parse('$baseUrl/classrooms/join');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': DataHolder.currentUser?.userId ?? 0,
          'classroomId': classroomId,
          'role': role,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to join classroom: ${response.body}');
      }
    } catch (e) {
      throw Exception('An error occurred while joining the classroom: $e');
    }
  }

  /// Load all classrooms for a user
  static Future<List<ClassroomData>> loadAllClassroomsForUser(int userId) async {
    final url = Uri.parse('$baseUrl/classrooms/user/$userId');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        return responseData.map((data) => ClassroomData.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load classrooms: ${response.body}');
      }
    } catch (e) {
      throw Exception('An error occurred while loading classrooms: $e');
    }
  }

  /// Leave a classroom
  static Future<void> leaveClassroom(int classroomId) async {
    final url = Uri.parse('$baseUrl/classrooms/leave');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': DataHolder.currentUser?.userId ?? 0,
          'classroomId': classroomId,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to leave classroom: ${response.body}');
      }
    } catch (e) {
      throw Exception('An error occurred while leaving the classroom: $e');
    }
  }

  int getIdByCode(String classroomCode) {
    // return classroomId by classroomCode
    return -1;
  }

  /// Remove a student from a classroom
  static Future<void> removeStudent(int userId, int classroomId) async {
    final url = Uri.parse('$baseUrl/classrooms/remove-student');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'classroomId': classroomId,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to remove student: ${response.body}');
      }
    } catch (e) {
      throw Exception('An error occurred while removing the student: $e');
    }
  }
}

class UserClassroomData {
  final int userId;
  final int classroomId;  // Changed to int for sequential ID
  final String role;

  UserClassroomData({
    required this.userId,
    required this.classroomId,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'classroomId': classroomId,
      'role': role,
    };
  }

  factory UserClassroomData.fromJson(Map<String, dynamic> json) {
    return UserClassroomData(
      userId: json['userId'],
      classroomId: json['classroomId'],
      role: json['role'],
    );
  }
}
