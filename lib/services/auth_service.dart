import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../core/network/api_service.dart';

class AuthService {
  final ApiService _api = ApiService();

  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'auth_user';

  // ── Singleton ──
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  // ── Login ──────────────────────────────────────────────────────────────
  Future<AuthResult> login({
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      // Simulation of a network delay
      await Future.delayed(const Duration(seconds: 1));

      // MOCK LOGIC: Accept any login for demo purposes
      // In a real app, you might check against locally saved users
      
      final user = UserModel(
        id: DateTime.now().millisecondsSinceEpoch,
        fullName: email.split('@').first.toUpperCase(),
        email: email,
        role: role,
        token: 'mock-jwt-token-${DateTime.now().millisecondsSinceEpoch}',
      );
      
      _currentUser = user;
      await _saveSession(user);
      return AuthResult.success(user);
    } catch (e) {
      return AuthResult.failure(e.toString());
    }
  }

  // ── Register ───────────────────────────────────────────────────────────
  Future<AuthResult> register({
    required String userName,
    required String email,
    required String password,
    required String role,
    required String phoneNumber,
    required String firstName,
    required String lastName,
    required String dateOfBirth,
    required int gender,
    required String address,
    String? licenseId,
  }) async {
    try {
      // Simulation of a network delay
      await Future.delayed(const Duration(seconds: 1));

      // MOCK LOGIC: Always succeed and create a local user
      final user = UserModel(
        id: DateTime.now().millisecondsSinceEpoch,
        fullName: "$firstName $lastName",
        email: email,
        role: role,
        token: 'mock-token-after-register-${DateTime.now().millisecondsSinceEpoch}',
      );
      
      _currentUser = user;
      await _saveSession(user);
      return AuthResult.success(user);
    } catch (e) {
      return AuthResult.failure(e.toString());
    }
  }

  // ── Logout ─────────────────────────────────────────────────────────────
  Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }

  // ── Restore session on app start ───────────────────────────────────────
  Future<UserModel?> restoreSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);
      if (userJson != null) {
        final user = UserModel.fromJson(jsonDecode(userJson));
        _currentUser = user;
        return user;
      }
    } catch (_) {}
    return null;
  }

  // ── Save session to local storage ──────────────────────────────────────
  Future<void> _saveSession(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    if (user.token != null) await prefs.setString(_tokenKey, user.token!);
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  // ── Get auth header for subsequent requests ────────────────────────────
  Future<Map<String, String>> getAuthHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

// ── Result wrapper ──────────────────────────────────────────────────────────
class AuthResult {
  final bool isSuccess;
  final UserModel? user;
  final String? errorMessage;

  AuthResult._({required this.isSuccess, this.user, this.errorMessage});

  factory AuthResult.success(UserModel user) =>
      AuthResult._(isSuccess: true, user: user);

  factory AuthResult.failure(String message) =>
      AuthResult._(isSuccess: false, errorMessage: message);
}

// Global instance
final authService = AuthService();
