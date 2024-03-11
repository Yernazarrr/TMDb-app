import 'package:flutter/material.dart';
import 'package:themdb_app/ui/features/app/app.dart';
import 'package:themdb_app/ui/features/app/my_app_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final model = MyAppModel();
  model.checkAuth;
  runApp(MovieApp(model: model));
}
