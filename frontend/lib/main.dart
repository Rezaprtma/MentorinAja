//**
// frontend/main.dart
//
// frontend:
// Production entrypoint. Menjalankan aplikasi untuk production.
//
// backend:
// File ini tidak memiliki dependency langsung terhadap backend.
//
// api:
// File ini tidak mendefinisikan atau memanggil API secara langsung.
//
// qa:
// QA perlu memvalidasi app startup dan initialization.
//**
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:frontend/app/app.dart';
import 'package:frontend/app/bootstrap.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await AppBootstrap.initialize();
  runApp(const App());
}
