import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Sign in session
  Future<AuthResponse> signInWithEmailPassword(
      String email, String password) async {
    return await _supabase.auth
        .signInWithPassword(password: password, email: email);
  }

  // Sign up session
  Future<AuthResponse> signUpWithEmailPassword(
      String email, String password, String name) async {
    return await _supabase.auth
        .signUp(email: email, password: password, data: {"Name": name});
  }

  // LogOut session
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Get user email
  Map getUserCurrentEmail() {
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    String? email = user?.email;
    String? name = user?.userMetadata!['Name'];
    return {email: email, name: name};
  }

  Future<Map<String, dynamic>?> getCurrentUserData() async {
    final user = _supabase.auth.currentUser;

    if (user == null) return null;

    return {
      'id': user.id,
      'email': user.email,
      'full_name': user.userMetadata?['full_name'] ?? '-',
      'created_at': user.createdAt,
    };
  }

  Future<void> updateDisplayName(String newName) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    final response = await _supabase.auth.updateUser(UserAttributes(data: {
      'full_name': newName,
    }));

    if (response.user != null) {
      debugPrint('User updated successfully');
    } else {
      debugPrint('Failed to update user');
    }
  }
}