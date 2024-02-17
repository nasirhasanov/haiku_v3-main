import 'package:haiku/utilities/constants/app_texts.dart';
import 'package:rxdart/rxdart.dart';

import '../../utilities/extensions/string_extensions.dart';

mixin LoginMixin {
  late final BehaviorSubject<String?> emailSubject = BehaviorSubject<String?>();
  late final BehaviorSubject<String?> passwordSubject = BehaviorSubject<String?>();

  Stream<String?> get emailStream => emailSubject.stream;
  Stream<String?> get passwordStream => passwordSubject.stream;

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
    } else if (value.isNotEmpty) {
      passwordSubject.sink.add(value);
    } else {
      passwordSubject.sink.add(null);
      passwordSubject.sink.addError(AppTexts.passwordWarning);
    }
  }
}