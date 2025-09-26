import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class ApiService {
  static const String _baseUrl = 'http://localhost:5000';

  // Get user's subjects from backend
  static Future<List<Map<String, dynamic>>> getUserSubjects() async {
    try {
      final accessToken = await AuthService.getAccessToken();
      if (accessToken == null) {
        print('❌ No access token available');
        return [];
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/api/subjects'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      print('🔍 Subjects API Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['success'] == true && responseData['data'] != null) {
          final subjects = responseData['data']['subjects'] as List<dynamic>;
          return subjects.cast<Map<String, dynamic>>();
        }
      }
      
      return [];
    } catch (e) {
      print('❌ Error fetching user subjects: $e');
      return [];
    }
  }

  // Get all available boards
  static Future<List<Map<String, dynamic>>> getAllBoards() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/boards'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['success'] == true && responseData['data'] != null) {
          final boards = responseData['data']['boards'] as List<dynamic>;
          return boards.cast<Map<String, dynamic>>();
        }
      }
      
      return [];
    } catch (e) {
      print('❌ Error fetching boards: $e');
      return [];
    }
  }

  // Get all available classes
  static Future<List<Map<String, dynamic>>> getAllClasses() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/classes'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['success'] == true && responseData['data'] != null) {
          final classes = responseData['data']['classes'] as List<dynamic>;
          return classes.cast<Map<String, dynamic>>();
        }
      }
      
      return [];
    } catch (e) {
      print('❌ Error fetching classes: $e');
      return [];
    }
  }

  // Get user profile with fresh data from backend
  static Future<Map<String, dynamic>?> refreshUserProfile() async {
    try {
      final result = await AuthService.getUserProfile();
      if (result['success'] == true) {
        return result['user'];
      }
      return null;
    } catch (e) {
      print('❌ Error refreshing user profile: $e');
      return null;
    }
  }
}