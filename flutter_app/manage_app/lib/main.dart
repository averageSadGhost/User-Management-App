import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:manage_app/screens/login_screen.dart';
import 'package:manage_app/controllers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(TokenController());

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Your App Title',
      home: LoginPage(),
    );
  }
}
