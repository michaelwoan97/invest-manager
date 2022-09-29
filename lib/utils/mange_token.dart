import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ManageToken {
  static saveAccessToken(val) async {
    const storage = FlutterSecureStorage();

    await storage.write(key: "accessToken", value: val);
  }

  static getAccessToken() async{
    const storage = FlutterSecureStorage();

    var value = await storage.read(key: "accessToken");
    return value;
  }

  static saveRefreshToken(val) async {
    const storage = FlutterSecureStorage();

    await storage.write(key: "refreshToken", value: val);
  }

  static getRefreshToken() async{
    const storage = FlutterSecureStorage();

    var value = await storage.read(key: "refreshToken");
    return value;
  }
}
