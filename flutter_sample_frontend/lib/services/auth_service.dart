import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Update this URL to match your backend server
  static const String _baseUrl = 'http://localhost:5000'; // Change this to your backend URL
  
  // Login method
  static Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/auth/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);
      
      if (response.statusCode == 200 && responseData['success'] == true) {
        // Save tokens to local storage
        await _saveTokens(
          responseData['data']['access_token'],
          responseData['data']['refresh_token'],
        );
        
        // Save user data
        await _saveUserData(responseData['data']['user']);
        
        return {
          'success': true,
          'message': responseData['message'],
          'user': responseData['data']['user'],
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Login failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: Unable to connect to server. Please check your internet connection.',
      };
    }
  }

  // Register method
  static Future<Map<String, dynamic>> register({
    required String username,
    required String password,
    String? email,
    String? fullName,
  }) async {
    try {
      final Map<String, dynamic> requestBody = {
        'username': username,
        'password': password,
      };
      
      if (email != null && email.isNotEmpty) {
        requestBody['email'] = email;
      }
      
      if (fullName != null && fullName.isNotEmpty) {
        requestBody['full_name'] = fullName;
      }

      final response = await http.post(
        Uri.parse('$_baseUrl/api/auth/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);
      
      if (response.statusCode == 201 && responseData['success'] == true) {
        // Save tokens to local storage
        await _saveTokens(
          responseData['data']['access_token'],
          responseData['data']['refresh_token'],
        );
        
        // Save user data
        await _saveUserData(responseData['data']['user']);
        
        return {
          'success': true,
          'message': responseData['message'],
          'user': responseData['data']['user'],
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Registration failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: Unable to connect to server. Please check your internet connection.',
      };
    }
  }

  // Save tokens to local storage
  static Future<void> _saveTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', accessToken);
    await prefs.setString('refresh_token', refreshToken);
  }

  // Save user data to local storage
  static Future<void> _saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', jsonEncode(userData));
    await prefs.setInt('user_id', userData['id']);
    await prefs.setString('username', userData['username']);
  }

  // Get stored access token
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  // Get stored user data
  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('user_data');
    if (userDataString != null) {
      return jsonDecode(userDataString);
    }
    return null;
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final accessToken = await getAccessToken();
    return accessToken != null && accessToken.isNotEmpty;
  }

  // Logout method
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
  
  // Clear all stored data (for debugging)
  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print('🧹 All local storage data cleared');
  }
  
  // Debug method to show stored data
  static Future<void> debugStoredData() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    print('🔍 Stored keys: $keys');
    
    for (final key in keys) {
      final value = prefs.get(key);
      print('   $key: $value');
    }
  }

  // Get user profile from backend
  static Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final accessToken = await getAccessToken();
      if (accessToken == null) {
        return {
          'success': false,
          'message': 'No access token found',
        };
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/api/auth/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);
      
      if (response.statusCode == 200 && responseData['success'] == true) {
        await _saveUserData(responseData['data']['user']);
        return {
          'success': true,
          'user': responseData['data']['user'],
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to get profile',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: Unable to connect to server',
      };
    }
  }

  // Refresh access token
  static Future<Map<String, dynamic>> refreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString('refresh_token');
      
      if (refreshToken == null) {
        return {
          'success': false,
          'message': 'No refresh token found',
        };
      }

      final response = await http.post(
        Uri.parse('$_baseUrl/api/auth/refresh'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $refreshToken',
        },
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);
      
      if (response.statusCode == 200 && responseData['success'] == true) {
        await prefs.setString('access_token', responseData['data']['access_token']);
        return {
          'success': true,
          'access_token': responseData['data']['access_token'],
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Token refresh failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: Unable to refresh token',
      };
    }
  }
}