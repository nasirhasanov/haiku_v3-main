part of 'login_cubit.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class LoginInitial extends LoginState {}
final class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final User? user;

  LoginSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class LoginFailure extends LoginState {
  final String? error;

  LoginFailure({this.error});

  @override
  List<Object?> get props => [error];
}

final class PasswordResetSent extends LoginState {}
