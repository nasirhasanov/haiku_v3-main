import 'package:haiku/data/data_sources/remote/firebase/auth/login_service.dart';
import 'package:haiku/locator.dart';

abstract class LoginRepositoryImpl {
  Future<bool> login();
}

class LoginRepository implements LoginRepositoryImpl {
  final LoginService _loginService = locator.get<LoginService>();

  @override
  Future<bool> login() async {
    bool isLogged = await _loginService.login();
    return isLogged;
  }
}
