import 'package:flutter/material.dart';

import 'package:frontend/app/app.dart';
import 'package:frontend/app/bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppBootstrap.initialize();
  runApp(const App());
}
