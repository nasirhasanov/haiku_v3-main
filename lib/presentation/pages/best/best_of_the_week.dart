import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haiku/cubits/best/best_authors_cubit.dart';
import 'package:haiku/data/models/user_info_model.dart';
import 'package:haiku/presentation/pages/best/widgets/best_user_list_item.dart';
import 'package:haiku/presentation/widgets/global/global_divider.dart';
import 'package:haiku/presentation/widgets/global/global_loading.dart';
import 'package:haiku/utilities/constants/app_texts.dart';

class BestOfTheWeek extends StatelessWidget {
  const BestOfTheWeek({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BestAuthorsCubit>();

    return Scaffold(
        appBar: AppBar(
          title: const Text(AppTexts.bestOfTheWeek),
        ),
        body: BlocBuilder<BestAuthorsCubit, BestAuthorsState>(
          builder: (context, state) {
            if (state is BestAuthorsSuccess) {
              return StreamBuilder<List<UserInfoModel>?>(
                  stream: cubit.usersStream,
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      var userList = snapshot.data;
                      return ListView.separated(
                        itemCount: userList?.length ?? 0,
                        separatorBuilder: (context, index) =>
                            const GlobalDivider.horizontal(left: 70),
                        itemBuilder: (context, index) {
                          final user = userList?[index];
                          return BestUserListItem(
                            userInfo: user,
                          );
                        },
                      );
                    }
                    return const Center(
                      child: Text('Some error occurred.'),
                    );
                  });
            } else if (state is BestAuthorsLoading ||
                state is BestAuthorsInitial) {
              return const GlobalLoading();
            }
            return const SizedBox.shrink();
          },
        ));
  }
}
