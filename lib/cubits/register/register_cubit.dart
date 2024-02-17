import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haiku/cubits/register/register_mixin.dart';
import 'package:haiku/data/services/user/update_user_data_service.dart';
import 'package:haiku/locator.dart';
import 'package:haiku/utilities/constants/app_texts.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> with RegisterMixin {
  RegisterCubit() : super(RegisterInitial());

  late final userDataService = locator<UpdateUserDataService>();

  void signUp() async {
    try {
      final email = await emailStream.first;
      final password = await passwordStream.first;
      final username = await usernameStream.first;

      if (email == null || password == null) {
        emit(RegisterFailure(error: AppTexts.pleaseFillFields));
        return;
      }
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        final result = await userDataService.update(
            username, credential.user?.uid, email, AppTexts.newUserBio, 1, 1);

        if (result) {
          emit(RegisterSuccess(credential.user));
        }
      } else {
        emit(RegisterFailure(error: AppTexts.anErrorOccurred));
      }

      print('User created');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(RegisterFailure(error: AppTexts.weakPasswordError));
      } else if (e.code == 'email-already-in-use') {
        emit(RegisterFailure(error: AppTexts.emailInUse));
      }
    } catch (e) {
      emit(RegisterFailure(error: AppTexts.anErrorOccurred));
    }
  }
}
