import 'package:firebase_core/firebase_core.dart';
import 'package:maya_app/widget_tree.dart';
import 'package:flutter/material.dart';
import 'package:maya_app/dashboard.dart' show MyDash;
import 'package:maya_app/signup.dart' show MySign;
Future<void> main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key?key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WidgetTree(),
    );
  }
}