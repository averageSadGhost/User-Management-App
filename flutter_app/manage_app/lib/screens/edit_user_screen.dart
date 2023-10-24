import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:manage_app/controllers.dart';
import 'package:manage_app/models.dart';
import 'package:manage_app/screens/admin_or_tutor.dart';
import 'package:manage_app/utils.dart';
import 'package:get/get.dart';

class EditUserScreen extends StatefulWidget {
  final int userId;

  const EditUserScreen({Key? key, required this.userId}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  final TokenController tokenController = Get.find<TokenController>();

  @override
  void initState() {
    super.initState();
    fetchUserData(widget.userId, tokenController.getToken()['token']);
  }

  Future<void> fetchUserData(int userId, String? token) async {
    try {
      final dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';

      final response = await dio.get('$url/users/$userId');

      if (response.statusCode == 200) {
        final userData = UserDataEdit.fromJson(response.data);
        usernameController.text = userData.username;
        emailController.text = userData.email;
        passwordController.text = userData.password;
      } else {
        debugPrint('Failed to fetch user data');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<void> updateUser() async {
    try {
      final dio = Dio();
      dio.options.headers['Authorization'] =
          'Bearer ${tokenController.getToken()['token']}';

      final userData = UserDataEdit(
        username: usernameController.text,
        email: emailController.text,
        password: passwordController.text,
      );

      final response =
          await dio.put('$url/users/${widget.userId}', data: userData.toJson());

      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('User updated.')));
        Get.offAll(const AdminOrTutor());
      } else {
        debugPrint('Failed to update user data');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            ElevatedButton(
              onPressed: updateUser,
              child: const Text('Update User'),
            ),
          ],
        ),
      ),
    );
  }
}
