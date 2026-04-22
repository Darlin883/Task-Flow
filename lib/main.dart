import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:task_flow_manager/firebase_options.dart';
import 'package:task_flow_manager/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const TaskFlowApp());
}

class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskFlow',
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}