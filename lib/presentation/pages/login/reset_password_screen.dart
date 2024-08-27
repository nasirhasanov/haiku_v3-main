import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haiku/presentation/widgets/global/global_button.dart';
import 'package:haiku/presentation/widgets/global/global_loading.dart';
import 'package:haiku/utilities/constants/app_text_styles.dart';
import 'package:haiku/utilities/helpers/alerts.dart';
import '../../../cubits/login/login_cubit.dart';
import '../../../utilities/constants/app_sized_boxes.dart';
import '../../../utilities/constants/app_texts.dart';
import 'widgets/login_email_input.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppTexts.resetPassword),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is PasswordResetSent) {
              Alerts.showResetPasswordInfoDialog(
                  context, true, AppTexts.resetPasswordSent);
            } else if (state is LoginFailure) {
              Alerts.showResetPasswordInfoDialog(
                  context, false, state.error ?? AppTexts.anErrorOccurred);
            }
          },
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                const Text(
                  AppTexts.provideEmailPasswordReset,
                  style: AppTextStyles.normalGrey20,
                  textAlign: TextAlign.center, // Center the text
                ),
                AppSizedBoxes.h8,
                const LoginEmailInput(),
                const Spacer(),
                AppSizedBoxes.h8,
                AppSizedBoxes.h20,
                if (state is LoginLoading)
                  const GlobalLoading()
                else
                  StreamBuilder<bool>(
                    stream: context
                        .read<LoginCubit>()
                        .emailStream
                        .map((email) => email != null),
                    builder: (context, snapshot) {
                      final isButtonEnabled = snapshot.data ?? false;
                      return GlobalButton(
                        buttonText: AppTexts.done,
                        isEnabled: isButtonEnabled,
                        onPressed: () =>
                            context.read<LoginCubit>().resetPassword(),
                      );
                    },
                  ),
                AppSizedBoxes.h20,
              ],
            );
          },
        ),
      ),
    );
  }
}
