import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haiku/data/repository/user_repository.dart';
import 'package:haiku/locator.dart';
import 'package:haiku/utilities/helpers/auth_utils.dart';

part 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  AccountCubit() : super(AccountInitial());

  late final _userInfoService = locator<UserRepositoryImpl>();

  Future<bool?> changePassword(
    String email,
    String oldPassword,
    String newPassword,
  ) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: oldPassword,
      );
      await AuthUtils().currentUser?.updatePassword(newPassword);

      emit(ChangePasswordSuccess());
    } on FirebaseException catch (e) {
      emit(ChangePasswordFailure(error: e.message));
    } catch (e) {
      emit(ChangePasswordFailure(error: e.toString()));
    }
  }

  Future<bool?> deleteAccount(
    String email,
    String password,
  ) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _userInfoService.deleteUser();

      await AuthUtils().currentUser?.delete();

      emit(DeleteAccountSuccess());
    } on FirebaseException catch (e) {
      emit(DeleteAccountFailure(error: e.message));
    } catch (e) {
      emit(DeleteAccountFailure(error: e.toString()));
    }
  }
}
