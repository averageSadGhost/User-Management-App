import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manage_app/models.dart';
import 'package:manage_app/screens/login_screen.dart';

import 'package:manage_app/controllers.dart';
import 'package:manage_app/utils.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _StudentScreenState createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  UserData? userData; // Store the user data here
  final TokenController tokenController = Get.find<TokenController>();

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    final String token = tokenController.getToken()['token']!;

    final dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';

    try {
      final response = await dio.get('$url/users/me');

      if (response.statusCode == 200) {
        final fetchedUserData = UserData.fromJson(response.data);

        setState(() {
          userData = fetchedUserData;
        });
      } else {
        debugPrint('Failed to fetch user data');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void logout() {
    // Clear the token and type when logging out
    tokenController.clearToken();

    Get.offAll(LoginPage());
    // You can navigate to the login screen or perform other actions as needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Screen'),
        actions: <Widget>[
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout), // Use a logout icon here
          ),
        ],
      ),
      body: Center(
        child: userData == null
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('User Data: '),
                  Text('Email: ${userData!.email}'),
                  Text('ID: ${userData!.id}'),
                  Text('Password: ${userData!.password}'),
                  Text('Username: ${userData!.username}'),
                  Text('Type: ${userData!.type}'),
                  Text('Created at: ${userData!.createdDate}'),
                ],
              ),
      ),
    );
  }
}
