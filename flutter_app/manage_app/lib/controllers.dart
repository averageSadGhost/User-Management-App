import 'package:get/get.dart';

class TokenController extends GetxController {
  var token = ''.obs;
  var type = ''.obs;

  void setToken(String newToken, String userType) {
    token.value = newToken;
    type.value = userType;
  }

  Map<String, String> getToken() {
    return {
      'token': token.value,
      'type': type.value,
    };
  }

  void clearToken() {
    token.value = '';
    type.value = '';
  }
}
