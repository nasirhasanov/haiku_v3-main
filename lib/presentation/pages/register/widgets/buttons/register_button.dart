import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haiku/presentation/widgets/global/global_button.dart';
import 'package:haiku/utilities/constants/app_texts.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../cubits/register/register_cubit.dart';

class RegisterButton extends StatelessWidget {
  const RegisterButton({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RegisterCubit>();
    return StreamBuilder<bool>(
        stream: CombineLatestStream.combine3(
            cubit.emailStream,
            cubit.usernameStream,
            cubit.passwordStream,
            (String? a, String? b, String? c) =>
                (a != null && b != null && c != null)),
        builder: (context, snapshot) {
          final isButtonEnabled = snapshot.data ?? false;

          return GlobalButton(
            buttonText: AppTexts.signUp,
            isEnabled: isButtonEnabled,
            onPressed: () {
              cubit.signUp();
            },
          );
        });
  }
}
