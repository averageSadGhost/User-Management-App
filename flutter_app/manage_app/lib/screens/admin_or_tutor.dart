import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manage_app/models.dart';
import 'package:manage_app/screens/create_user.dart';
import 'package:manage_app/screens/edit_user_screen.dart';
import 'package:manage_app/screens/login_screen.dart';

import 'package:manage_app/controllers.dart';
import 'package:manage_app/utils.dart';

class AdminOrTutor extends StatefulWidget {
  const AdminOrTutor({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AdminOrTutorState createState() => _AdminOrTutorState();
}

class _AdminOrTutorState extends State<AdminOrTutor> {
  List<UserDataFromApi> availableUsers = [];
  final TokenController tokenController = Get.find<TokenController>();

  @override
  void initState() {
    super.initState();
    getAvailableUsers();
  }

  Future<void> getAvailableUsers() async {
    final String token = tokenController.getToken()['token']!;

    final dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';

    try {
      final response = await dio.get('$url/users/');

      if (response.statusCode == 200) {
        final userList = (response.data as List)
            .map((user) => UserDataFromApi.fromJson(user))
            .toList();

        setState(() {
          availableUsers = userList;
        });
      } else {
        debugPrint('Failed to fetch available users');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void logout() {
    tokenController.clearToken();
    Get.off(LoginPage());
  }

  void createUser() {
    Get.to(const AddUserScreen());
  }

  void showDeleteConfirmationDialog(UserDataFromApi user) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete User'),
          content: const Text('Are you sure you want to delete this user?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                deleteSelectedUser(user);
                Get.offAll(const AdminOrTutor());
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void deleteSelectedUser(UserDataFromApi user) {
    final userId = user.id;
    final token = tokenController.getToken()['token'];
    final dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';

    dio.delete('$url/users/$userId').then((response) {
      if (response.statusCode == 204) {
        getAvailableUsers();
      } else {
        debugPrint('Failed to delete user with ID: $userId');
      }
    }).catchError((error) {
      debugPrint('Error: $error');
    });
  }

  void editUser(UserDataFromApi user) {
    Get.to(
      EditUserScreen(userId: user.id), // Pass the user's ID as an argument
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin/Tutor Screen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
          ),
        ],
      ),
      body: Center(
        child: availableUsers.isEmpty
            ? const CircularProgressIndicator()
            : ListView.builder(
                itemCount: availableUsers.length,
                itemBuilder: (context, index) {
                  final user = availableUsers[index];
                  return ListTile(
                    title: Text("id:${user.id} ${user.username}"),
                    subtitle: Text(user.email),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            editUser(user); // Handle edit action
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDeleteConfirmationDialog(user);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createUser,
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}
