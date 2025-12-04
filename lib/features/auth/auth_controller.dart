import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:my_routine/services/cloud_sync_service.dart';
import 'package:hive/hive.dart';

class AuthController extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  final CloudSyncService _syncService = CloudSyncService();

  User? get currentUser => _supabase.auth.currentUser;

  bool get isLoggedIn => currentUser != null;

  Future<void> loginWithEmail(String email, String password) async {
    try {
      await _supabase.auth.signInWithPassword(email: email, password: password);
      await _syncService.loadCloudDataOnLogin();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signupWithEmail(String email, String password) async {
    try {
      await _supabase.auth.signUp(email: email, password: password);
      // New user, nothing to sync down, but maybe sync up empty state?
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.myroutine://login-callback',
      );
      // Note: OAuth flow might redirect, so sync might need to happen on app resume or init
      // For now, we assume successful return triggers this if handled manually,
      // but Supabase OAuth usually handles this via deep links.
      // We might need to listen to auth state changes in main.dart or here.
    } catch (e) {
      rethrow;
    }
  }

  bool _isGuest = false;
  bool get isGuest => _isGuest;

  void setGuestMode(bool value) {
    _isGuest = value;
    notifyListeners();
  }

  Future<void> continueWithoutLogin() async {
    _isGuest = true;
    notifyListeners();
  }

  Future<void> logout() async {
    _isGuest = false;
    await _supabase.auth.signOut();

    // Clear local data on logout to prevent data leak to next user
    await Hive.box('tasks').clear();
    await Hive.box('summaries').clear();
    await Hive.box('diary').clear();
    await Hive.box('goals').clear();
    await Hive.box('progress').clear();

    notifyListeners();
  }
}
