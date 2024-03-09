part of 'best_authors_cubit.dart';

sealed class BestAuthorsState extends Equatable {
  const BestAuthorsState();

  @override
  List<Object> get props => [];
}

final class BestAuthorsInitial extends BestAuthorsState {}

final class BestAuthorsLoading extends BestAuthorsState {}

final class BestAuthorsSuccess extends BestAuthorsState {}

final class BestAuthorsError extends BestAuthorsState {}