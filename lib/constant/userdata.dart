import 'package:app/function/pluginfunction.dart';

class User {
  String? token;
  String? changepassToken;
  setPassToken() async {
    await SharedPref().save('passtoken', changepassToken);
  }

  Future getPassToken() async {
    var reading = await SharedPref().read('passtoken');
    if (reading != null) {
    } else {}
    changepassToken = reading;
  }

  setToken() async {
    await SharedPref().save('registertoken', token);
  }

  Future getToken() async {
    var reading = await SharedPref().read('registertoken');
    if (reading != null) {
    } else {}
    token = reading;
  }
}
