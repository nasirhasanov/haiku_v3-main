import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:haiku/data/data_sources/remote/firebase/feed/following_post_service.dart';
import 'package:haiku/data/repository/location_repository.dart';
import 'package:haiku/data/repository/notifications_repository.dart';
import 'package:haiku/data/repository/talks_repository.dart';
import 'package:haiku/data/data_sources/remote/firebase/best/best_users_service.dart';
import 'package:haiku/data/data_sources/remote/firebase/feed/author_posts_service.dart';
import 'package:haiku/data/data_sources/remote/firebase/feed/my_post_service.dart';
import 'package:haiku/data/services/location/location_service.dart';
import 'package:haiku/data/data_sources/remote/firebase/notifications/notifications_service.dart';
import 'package:haiku/data/data_sources/remote/firebase/post/delete_post_service.dart';
import 'package:haiku/data/data_sources/remote/firebase/talks/talks_service.dart';
import 'package:haiku/data/data_sources/remote/firebase/user/update_user_data_service.dart';
import 'package:haiku/data/data_sources/remote/firebase/user/user_info_service.dart';
import 'package:haiku/data/data_sources/remote/firebase/user/follow_service.dart';

import 'data/contracts/auth_contract.dart';
import 'data/contracts/post_contract.dart';
import 'data/repository/auth_repository.dart';
import 'data/repository/post_repository.dart';
import 'data/repository/user_repository.dart';
import 'data/data_sources/remote/firebase/auth/login_service.dart';
import 'data/data_sources/remote/firebase/auth/register/username_service.dart';
import 'data/data_sources/remote/firebase/feed/local_post_service.dart';
import 'data/data_sources/remote/firebase/feed/mix_posts_service.dart';
import 'data/data_sources/remote/firebase/feed/new_post_service.dart';
import 'data/data_sources/remote/firebase/user/profile_pic_service.dart';

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
  locator.registerLazySingleton(() => NotificationsService());
  locator.registerLazySingleton(() => FollowingPostService());
  locator.registerLazySingleton<FollowService>(() => FollowService());

  locator.registerLazySingleton<PostContract>(() => PostRepository(
        locator<NewPostService>(),
        locator<MixPostsService>(),
        locator<LocalPostService>(),
        locator<MyPostService>(),
        locator<AuthorPostService>(),
      ));

  locator.registerLazySingleton<UserRepositoryImpl>(() =>
      UserRepository(locator<ProfilePicService>(), locator<UserInfoService>()));

  locator.registerLazySingleton<LocationRepositoryImpl>(
      () => LocationRepository(locator<LocationService>()));

  locator.registerLazySingleton<TalksRepositoryImpl>(
      () => TalksRepository(locator<TalksService>()));

  locator.registerLazySingleton<NotificationRepositoryImpl>(
      () => NotificationRepository(locator<NotificationsService>()));

  locator.registerLazySingleton<AuthContract>(() => AuthRepository(
        locator<UsernameService>(),
      ));
}
