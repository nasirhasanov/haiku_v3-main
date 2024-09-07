import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haiku/cubits/author/author_profile_cubit.dart';
import 'package:haiku/presentation/pages/author/widgets/author_info_app_bar_widget.dart';
import 'package:haiku/presentation/pages/home/widgets/feed_builder.dart';

class AuthorProfilePage extends StatelessWidget {
  const AuthorProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthorProfileCubit>();

    return Scaffold(
      appBar: AppBar(),
      // body: NestedScrollView(
      //   headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
      //     return <Widget>[
      //       const AuthorInfoAppBarWidget(),
      //     ];
      //   },
      //   body: FeedBuilder(
      //     scrollController: cubit.authorPostScrollController,
      //     stream: cubit.authorPostStream,
      //     onRefresh: () async => await cubit.getAuthorPosts(isRefresh: true),
      //   ),
      // ),
      body: CustomScrollView(
        controller: cubit.authorPostScrollController,
        slivers: [
          const AuthorInfoAppBarWidget(),
          FeedBuilder(
            // scrollController: cubit.myPostScrollController,
            stream: cubit.authorPostStream,
            // onRefresh: () async => await cubit.getMyPosts(isRefresh: true),
          ),
        ],
      ),
    );
  }
}
