import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haiku/presentation/widgets/global/global_button.dart';
import 'package:haiku/utilities/constants/app_texts.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../cubits/login/login_cubit.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    final loginCubit = context.read<LoginCubit>();
    return StreamBuilder<bool>(
        stream: CombineLatestStream.combine2(
          loginCubit.emailStream,
          loginCubit.passwordStream,
          (String? a, String? b) => (a != null && b != null),
        ),
        builder: (context, snapshot) {

          final isButtonEnabled = snapshot.data ?? false;

          return GlobalButton(
            buttonText: AppTexts.signIn,
            isEnabled: isButtonEnabled,
            onPressed: () {
              loginCubit.signIn();
            },
          );
        });
  }
}
