part of 'author_profile_cubit.dart';

sealed class AuthorProfileState extends Equatable {
  const AuthorProfileState();

  @override
  List<Object> get props => [];
}

final class AuthorProfileInitial extends AuthorProfileState {}

final class AuthorProfileLoading extends AuthorProfileState {}

final class AuthorProfileSuccess extends AuthorProfileState {}

final class AuthorProfileError extends AuthorProfileState {}
