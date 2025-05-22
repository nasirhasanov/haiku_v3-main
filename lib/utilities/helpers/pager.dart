import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haiku/cubits/account/account_cubit.dart';
import 'package:haiku/cubits/author/author_profile_cubit.dart';
import 'package:haiku/cubits/best/best_authors_cubit.dart';
import 'package:haiku/cubits/notifications/notification_cubit.dart';
import 'package:haiku/cubits/talks/talks_cubit.dart';
import 'package:haiku/cubits/user/profile_cubit.dart';
import 'package:haiku/presentation/pages/account/views/change_bio_screen.dart';
import 'package:haiku/presentation/pages/account/views/change_password_screen.dart';
import 'package:haiku/presentation/pages/account/views/delete_account_screen.dart';
import 'package:haiku/presentation/pages/add/add_post_page.dart';
import 'package:haiku/presentation/pages/author/author_profile_page.dart';
import 'package:haiku/presentation/pages/best/best_of_the_week.dart';
import 'package:haiku/presentation/pages/home/views/show_profile_pic_full_screen.dart';
import 'package:haiku/presentation/pages/login/reset_password_screen.dart';
import 'package:haiku/presentation/pages/talks/talks_page.dart';

import '../../cubits/home/home_cubit.dart';
import '../../cubits/login/login_cubit.dart';
import '../../cubits/register/register_cubit.dart';
import '../../presentation/pages/best/search/search_users_page.dart';
import '../../presentation/pages/home/home_page.dart';
import '../../presentation/pages/login/login_page.dart';
import '../../presentation/pages/register/register_page.dart';
import '../../utilities/helpers/auth_utils.dart';

class Pager {
  Pager._();

  static Widget get home => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) {
              final cubit = HomeCubit();
              AuthUtils().userStream.listen((user) {
                // Only load the initial feed with new posts
                cubit.loadInitialFeed();
              });
              return cubit;
            },
          ),
          BlocProvider(
            create: (context) => ProfileCubit()..loadProfile(),
          ),
          BlocProvider(
            create: (context) => NotificationCubit()..getAllNotifications(),
          )
        ],
        child: const HomePage(),
      );

  static Widget get register => BlocProvider(
        create: (context) => RegisterCubit(),
        child: const RegisterPage(),
      );

  static Widget get login => BlocProvider(
        create: (context) => LoginCubit(),
        child: const LoginPage(),
      );
  static Widget get resetPassword => BlocProvider(
        create: (context) => LoginCubit(),
        child: const ResetPasswordScreen(),
      );

  static Widget get addPost => BlocProvider(
        create: (context) => ProfileCubit()..loadUserInfo(),
        child: const AddPostPage(),
      );

  static Widget talks({
    required String postId,
    required String posterId,
  }) =>
      BlocProvider(
        create: (context) => TalksCubit(
          postId: postId,
          posterId: posterId,
        )..getPostTalks(),
        child: const TalksPage(),
      );

  static Widget showAuthor({
    required String authorId,
  }) =>
      BlocProvider(
        create: (context) =>
            AuthorProfileCubit(authorId: authorId)..loadProfile(),
        child: const AuthorProfilePage(),
      );

  static Widget showProfilePic({
    required String profilePicUrl,
  }) =>
      ShowProfilePicFullScreen(imageUrl: profilePicUrl);

  static Widget get changeBio => BlocProvider(
        create: (context) => ProfileCubit(),
        child: const ChangeBioPage(),
      );

  static Widget get changePassword => BlocProvider(
        create: (context) => AccountCubit(),
        child: const ChangePasswordPage(),
      );

  static Widget get deleteAccount => BlocProvider(
        create: (context) => AccountCubit(),
        child: const DeleteAccountPage(),
      );

  static Widget get showBestAuthors => BlocProvider(
        create: (context) => BestAuthorsCubit()..getBestAuthors(),
        child: const BestOfTheWeek(),
      );

  static Widget get searchUsers => const SearchUsersPage();

}
