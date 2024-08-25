import 'package:haiku/data/contracts/auth_contract.dart';
import 'package:haiku/data/data_sources/remote/firebase/auth/register/username_service.dart';

class AuthRepository implements AuthContract {
  AuthRepository(this._usernameService);

  final UsernameService _usernameService;

  @override
  Future<String?> checkUsernameExist(String username) =>
      _usernameService.checkUsernameExist(username);
}
