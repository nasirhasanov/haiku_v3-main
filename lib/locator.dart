import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:haiku/data/repository/location_repository.dart';
import 'package:haiku/data/repository/talks_repository.dart';
import 'package:haiku/data/services/best/best_users_service.dart';
import 'package:haiku/data/services/feed/author_posts_service.dart';
import 'package:haiku/data/services/feed/my_post_service.dart';
import 'package:haiku/data/services/location/location_service.dart';
import 'package:haiku/data/services/post/delete_post_service.dart';
import 'package:haiku/data/services/talks/talks_service.dart';
import 'package:haiku/data/services/user/update_user_data_service.dart';
import 'package:haiku/data/services/user/user_info_service.dart';

import 'data/contracts/auth_contract.dart';
import 'data/contracts/post_contract.dart';
import 'data/repository/auth_repository.dart';
import 'data/repository/post_repository.dart';
import 'data/repository/user_repository.dart';
import 'data/services/auth/login_service.dart';
import 'data/services/auth/register/username_service.dart';
import 'data/services/feed/local_post_service.dart';
import 'data/services/feed/mix_posts_service.dart';
import 'data/services/feed/new_post_service.dart';
import 'data/services/user/profile_pic_service.dart';

final GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  locator.registerLazySingleton(() => FirebaseFirestore.instance);

  locator.registerLazySingleton(() => PlatformDispatcher.instance.locale);

  locator.registerLazySingleton(() => LoginService);
  locator.registerLazySingleton(() => NewPostService());
  locator.registerLazySingleton(() => MixPostsService());
  locator.registerLazySingleton(() => LocalPostService());
  locator.registerLazySingleton(() => MyPostService());
  locator.registerLazySingleton(() => ProfilePicService());
  locator.registerLazySingleton(() => UsernameService());
  locator.registerLazySingleton(() => UserInfoService());
  locator.registerLazySingleton(() => LocationService());
  locator.registerLazySingleton(() => DeleteStoryService());
  locator.registerLazySingleton(() => TalksService());
  locator.registerLazySingleton(() => AuthorPostService());
  locator.registerLazySingleton(() => UpdateUserDataService());
  locator.registerLazySingleton(() => BestUsersService());

  locator.registerLazySingleton<PostContract>(() => PostRepository(
        locator<NewPostService>(),
        locator<MixPostsService>(),
        locator<LocalPostService>(),
        locator<MyPostService>(),
        locator<AuthorPostService>(),
      ));

  locator.registerLazySingleton<UserRepositoryImpl>(() =>
      UserRepository(locator<ProfilePicService>(), locator<UserInfoService>()));

  locator.registerLazySingleton<LocationRepositoryImpl>(() =>
      LocationRepository(locator<LocationService>()));

    locator.registerLazySingleton<TalksRepositoryImpl>(() =>
      TalksRepository(locator<TalksService>()));    

  locator.registerLazySingleton<AuthContract>(() => AuthRepository(
        locator<UsernameService>(),
      ));
}
