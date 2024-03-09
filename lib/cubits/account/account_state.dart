part of 'account_cubit.dart';

abstract class AccountState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class AccountInitial extends AccountState {}

final class ChangePasswordSuccess extends AccountState {}

class ChangePasswordFailure extends AccountState {
  final String? error;

  ChangePasswordFailure({this.error});

  @override
  List<Object?> get props => [error];
}

final class DeleteAccountSuccess extends AccountState {}

class DeleteAccountFailure extends AccountState {
  final String? error;

  DeleteAccountFailure({this.error});

  @override
  List<Object?> get props => [error];
}