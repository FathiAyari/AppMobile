import 'package:shared_preferences/shared_preferences.dart';
import 'package:showroom_front/data/entities/user_data.dart';

class SharedPrefsData {
  static Future<void> saveUserData(UserData user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("name", user.name);
    prefs.setString("lastname", user.lastname);
    prefs.setString("login", user.login);
    prefs.setString("password", user.password);
    prefs.setInt("age", user.age);
  }

  static Future<UserData> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var login = prefs.getString("login");
    if (login == null) {
      return null;
    } else {
      return UserData(
          age: prefs.getInt("age") ?? 0,
          lastname: prefs.getString("lastname") ?? "",
          login: login,
          name: prefs.getString("name") ?? "",
          password: prefs.getString("password") ?? "");
    }
  }

  static clearData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
