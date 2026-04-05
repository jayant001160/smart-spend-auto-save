import 'package:flutter/material.dart';
import 'package:frontend/injection_container.dart' as di;

import 'presentation/app_root.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const AppRoot());
}
