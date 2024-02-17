part of 'talks_cubit.dart';

sealed class TalksState extends Equatable {
  const TalksState();

  @override
  List<Object> get props => [];
}

final class TalksInitial extends TalksState {}
final class TalksLoading extends TalksState {}
final class TalksSuccess extends TalksState {}
final class TalksError extends TalksState {}
