import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manage_app/controllers.dart';
import 'package:manage_app/screens/admin_or_tutor.dart';
import 'package:manage_app/utils.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? selectedRole; // Store the selected role
  String? currentUserType;

  @override
  void initState() {
    super.initState();
    currentUserType = Get.find<TokenController>()
        .getToken()['type']; // Get the current user's type

    // Set selectedRole to "student" if the currentUserType is "tutor"
    if (currentUserType == 'tutor') {
      selectedRole = 'student';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 16),
            // Conditionally display the role dropdown based on user type
            if (selectedRole == null || currentUserType != 'tutor')
              DropdownButtonFormField<String>(
                value: selectedRole,
                items: const [
                  DropdownMenuItem<String>(
                    value: 'student',
                    child: Text('Student'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'admin',
                    child: Text('Admin'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'tutor',
                    child: Text('Tutor'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedRole = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Role',
                ),
              )
            else
              const Text(
                'As a tutor, you can only add students.',
                style: TextStyle(color: Colors.grey),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final email = emailController.text;
                final username = usernameController.text;
                final password = passwordController.text;

                if (selectedRole != null &&
                    email.isNotEmpty &&
                    username.isNotEmpty &&
                    password.isNotEmpty) {
                  final dio = Dio();

                  // Get the token from the tokenController
                  final token = Get.find<TokenController>().getToken()['token'];

                  // Check if the token is not null
                  if (token != null) {
                    // Add the token to the request headers
                    dio.options.headers['Authorization'] = 'Bearer $token';
                  } else {
                    // Handle the case where the token is null or missing
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Token is missing.')),
                    );
                    return;
                  }

                  final Map<String, dynamic> userData = {
                    'email': email,
                    'password': password,
                    'username': username,
                    'type': selectedRole,
                  };

                  try {
                    final response =
                        await dio.post('$url/users/create', data: userData);

                    if (response.statusCode == 201) {
                      // User created successfully, you can navigate back to the previous screen or take other actions.
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('User created.')),
                      );
                      Get.offAll(const AdminOrTutor());
                    } else {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Failed to create the user.')),
                      );
                    }
                  } catch (e) {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all fields.')),
                  );
                }
              },
              child: const Text('Add User'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
