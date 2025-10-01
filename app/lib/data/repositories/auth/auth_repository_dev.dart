// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import '../../../utils/result.dart';
import '../../services/shared_preferences_service.dart';
import 'auth_repository.dart';

class AuthRepositoryDev extends AuthRepository {
  AuthRepositoryDev({SharedPreferencesService? sharedPreferencesService})
      : _sharedPreferencesService = sharedPreferencesService ?? SharedPreferencesService();

  final SharedPreferencesService _sharedPreferencesService;
  
  /// Check authentication status based on stored token
  @override
  Future<bool> get isAuthenticated async {
    final result = await _sharedPreferencesService.fetchToken();
    switch (result) {
      case Ok():
        return result.value != null && result.value!.isNotEmpty;
      case Error():
        return false;
    }
  }

  /// Login with simple email/password validation for development
  @override
  Future<Result<void>> login({
    required String email,
    required String password,
  }) async {
    // Simple validation for development
    if (email == 'email@example.com' && password == 'password') {
      // Save a token to mark as logged in
      await _sharedPreferencesService.saveToken('dev_token_123');
      notifyListeners();
      return const Result.ok(null);
    } else {
      return Result.error(Exception('Invalid credentials'));
    }
  }

  /// Logout removes the token
  @override
  Future<Result<void>> logout() async {
    await _sharedPreferencesService.saveToken(null);
    notifyListeners();
    return const Result.ok(null);
  }
}
