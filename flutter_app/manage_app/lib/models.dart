class UserData {
  final String createdDate;
  final String password;
  final String username;
  final int id;
  final String email;
  final String type;

  UserData({
    required this.createdDate,
    required this.password,
    required this.username,
    required this.id,
    required this.email,
    required this.type,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      createdDate: json['created_date'],
      password: json['password'],
      username: json['username'],
      id: json['id'],
      email: json['email'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'created_date': createdDate,
      'password': password,
      'username': username,
      'id': id,
      'email': email,
      'type': type,
    };
  }
}

class UserDataFromApi {
  final int id;
  final String email;
  final String username;

  UserDataFromApi({
    required this.id,
    required this.email,
    required this.username,
  });

  factory UserDataFromApi.fromJson(Map<String, dynamic> json) {
    return UserDataFromApi(
      id: json['id'],
      email: json['email'],
      username: json['username'],
    );
  }
}

class UserDataEdit {
  final String email;
  final String username;
  final String password;

  UserDataEdit({
    required this.password,
    required this.email,
    required this.username,
  });

  factory UserDataEdit.fromJson(Map<String, dynamic> json) {
    return UserDataEdit(
      password: json['password'],
      email: json['email'],
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'email': email,
    };
  }
}
