import 'package:haiku/data/services/auth/register/register_service.dart';
import 'package:haiku/locator.dart';

abstract class RegisterRepositoryImpl {
  Future<bool> createAccount();
}

class RegisterRepository implements RegisterRepositoryImpl {
  final RegisterService _registerService = locator.get<RegisterService>();

  @override
  Future<bool> createAccount() async {
    bool isLogged = await _registerService.createAccount();
    return isLogged;
  }
}