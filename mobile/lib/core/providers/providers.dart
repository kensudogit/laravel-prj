import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Theme Mode Provider
final themeModeProvider = StateProvider<ThemeMode>((ref) {
  return ThemeMode.system;
});

// Shared Preferences Provider
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

// API Base URL Provider
final apiBaseUrlProvider = Provider<String>((ref) {
  // In development, use localhost
  // In production, use your actual API URL
  return 'http://10.0.2.2:8000/api'; // Android emulator localhost
  // return 'http://localhost:8000/api'; // iOS simulator localhost
  // return 'https://your-api-domain.com/api'; // Production
});

// Authentication State Provider
final authStateProvider = StateProvider<bool>((ref) {
  return false;
});

// User Provider
final userProvider = StateProvider<Map<String, dynamic>?>((ref) {
  return null;
});

// Loading State Provider
final loadingProvider = StateProvider<bool>((ref) {
  return false;
}); 