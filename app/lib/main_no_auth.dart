// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/dependencies.dart';
import 'main.dart';

/// Development config entry point without authentication.
/// Launch with `flutter run --target lib/main_no_auth.dart`.
/// Uses local data and clears any existing authentication.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Clear any existing authentication data
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('TOKEN');
  
  Logger.root.level = Level.ALL;

  runApp(MultiProvider(providers: providersLocal, child: const MainApp()));
}