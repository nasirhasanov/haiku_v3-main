import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:haiku/cubits/login/login_mixin.dart';
import 'package:haiku/data/data_sources/remote/firebase/user/user_info_service.dart';
import 'package:haiku/locator.dart';
import 'package:haiku/utilities/constants/app_texts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> with LoginMixin {
  LoginCubit() : super(LoginInitial());

    late final userInfoService = locator<UserInfoService>();


  void signIn() async {
    try {
      emit(LoginLoading());
      final email = await emailStream.first;
      final password = await passwordStream.first;

      if (email == null || password == null) {
        emit(LoginFailure(error: AppTexts.pleaseFillFields));
        return;
      }
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(LoginSuccess(credential.user));
      
      userInfoService.updateMessagingToken();

      print('User Logged In');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(LoginFailure(error: AppTexts.invalidCredentials));
      } else if (e.code == 'wrong-password') {
        emit(LoginFailure(error: AppTexts.invalidCredentials));
      }
    } catch (e) {
      emit(LoginFailure(error: AppTexts.anErrorOccurred));
    }
  }

  resetPassword() {}

  @override
  Future<void> close() {
    emailSubject.close();
    passwordSubject.close();
    return super.close();
  }
}
