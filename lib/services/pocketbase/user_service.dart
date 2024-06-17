import 'package:pocketbase/pocketbase.dart';

class UserService {
  static final PocketBase _pocketbase = PocketBase("http://192.168.0.199:8090");

  static Future<String?> getUserName(String? userId) async {
    if (userId == null) {
      return null;
    }

    try {
      final user = await _pocketbase.collection('users').getOne(userId);
      return user.data['name'] as String?;
    } catch (e) {
      print('Error retrieving user name: $e');
      return null;
    }
  }
}