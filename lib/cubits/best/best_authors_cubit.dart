import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haiku/data/models/post_model.dart';
import 'package:haiku/data/models/user_info_model.dart';
import 'package:haiku/data/data_sources/remote/firebase/best/best_users_service.dart';
import 'package:haiku/locator.dart';
import 'package:rxdart/rxdart.dart';

part 'best_authors_state.dart';

class BestAuthorsCubit extends Cubit<BestAuthorsState> {
  BestAuthorsCubit() : super(BestAuthorsInitial());

  late final service = locator<BestUsersService>();
  late final _usersSubject = BehaviorSubject<List<UserInfoModel>?>();
  ValueStream<List<UserInfoModel>?> get usersStream => _usersSubject.stream;

  Future<void> getBestAuthors() async {
    try {
      emit(BestAuthorsLoading());
      final users = await service.getBestOfWeekUsers();
      _usersSubject.add(users);
    } catch (_) {
      emit(BestAuthorsError());
    }
    emit(BestAuthorsSuccess());
  }
}
