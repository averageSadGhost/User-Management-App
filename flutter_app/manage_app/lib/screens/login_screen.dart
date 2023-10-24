import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:manage_app/screens/admin_or_tutor.dart';
import 'package:manage_app/screens/student_screen.dart';
import 'package:manage_app/controllers.dart';
import 'package:manage_app/utils.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});

  void login() async {
    final String email = emailController.text;
    final String password = passwordController.text;

    final dio = Dio(); // Create a Dio instance

    try {
      final response = await dio.post(
        "$url/auth/login", // Replace with your API URL
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        final String accessToken = data['access_token'];
        final String userType = data["user_type"];

        // Get the TokenController and set the token
        final TokenController tokenController = Get.find<TokenController>();
        tokenController.setToken(accessToken, userType);
        var type = tokenController.getToken()["type"];
        if (type == "student") {
          Get.off(const StudentScreen()); // Navigate to StudentScreen
        } else {
          Get.off(const AdminOrTutor());
        }
      }
    } catch (e) {
      final error = e as DioError;
      final errorMessage = error.response?.data['error'] ?? 'An error occurred';
      Get.snackbar(
        'Error',
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: login,
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
