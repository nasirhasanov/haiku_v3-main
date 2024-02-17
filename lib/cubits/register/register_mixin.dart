import 'package:haiku/data/contracts/auth_contract.dart';
import 'package:haiku/locator.dart';
import 'package:haiku/utilities/constants/app_texts.dart';
import 'package:haiku/utilities/helpers/input_debouncer.dart';
import 'package:rxdart/rxdart.dart';

import '../../utilities/extensions/string_extensions.dart';

mixin RegisterMixin {
  late final BehaviorSubject<String?> emailSubject = BehaviorSubject<String?>();
  late final BehaviorSubject<String?> usernameSubject = BehaviorSubject<String?>();
  late final BehaviorSubject<String?> passwordSubject = BehaviorSubject<String?>();

  late final _authContract = locator<AuthContract>();

  Stream<String?> get emailStream => emailSubject.stream;
  Stream<String?> get usernameStream => usernameSubject.stream;
  Stream<String?> get passwordStream => passwordSubject.stream;

  final Debouncer _debouncer = Debouncer(milliseconds: 500);

  void isUsernameExists(String value) async {
    _debouncer.run(() async {
      if (value.isEmpty) {
        usernameSubject.sink.add(null);
      } else {
        final username = await _authContract.checkUsernameExist(value);
        if (username == null) {
          usernameSubject.sink.add(value);
        } else {
          usernameSubject.sink.add(null);
          usernameSubject.sink.addError('This username exist.');
        }
      }
    });
  }

  void validateEmail(String value) {
    if (value.isEmpty) {
      emailSubject.sink.add(null);
    } else if (value.isEmailValid) {
      emailSubject.sink.add(value);
    } else {
      emailSubject.sink.add(null);
      emailSubject.sink.addError(AppTexts.emailInputWarning);
    }
  }

  void validatePassword(String value) {
    if (value.isEmpty) {
      passwordSubject.sink.add(null);
    } else if (value.length > 6) {
      passwordSubject.sink.add(value);
    } else {
      passwordSubject.sink.add(null);
      passwordSubject.sink.addError(AppTexts.passwordWarning);
    }
  }
}
