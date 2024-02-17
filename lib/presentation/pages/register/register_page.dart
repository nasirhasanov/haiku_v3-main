import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haiku/presentation/pages/register/widgets/inputs/register_password_input.dart';
import 'package:haiku/presentation/pages/register/widgets/signin_prompt.dart';
import 'package:haiku/presentation/pages/register/widgets/terms_and_privacy_text.dart';
import 'package:haiku/utilities/helpers/go.dart';
import 'package:haiku/utilities/helpers/pager.dart';

import '../../../cubits/register/register_cubit.dart';
import '../../../utilities/constants/app_sized_boxes.dart';
import '../../../utilities/constants/app_texts.dart';
import 'widgets/buttons/register_button.dart';
import 'widgets/inputs/register_username_input.dart';
import 'widgets/inputs/register_email_input.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RegisterCubit>();
    return Scaffold(
        appBar: AppBar(
          title: const Text(AppTexts.createAccount),
          centerTitle: true,
        ),
        body: BlocListener<RegisterCubit, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              Go.back(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Account Created!')),
              );
            } else if (state is RegisterFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error ?? 'Registration Failed')),
              );
            }
            // Handle other states if necessary
          },
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(flex: 1),
                const RegisterEmailInput(),
                AppSizedBoxes.h20,
                const RegisterUsernameInput(),
                AppSizedBoxes.h20,
                const RegisterPasswordInput(),
                AppSizedBoxes.h20,
                TermsAndPrivacyText(),
                AppSizedBoxes.h20,
                SignInPrompt(
                    messageText: AppTexts.haveAnAccount,
                    actionText: AppTexts.signIn,
                    onActionPressed: () {
                      Go.replace(context, Pager.login);
                    }),
                const Spacer(flex: 3),
                const RegisterButton(),
                AppSizedBoxes.h20
              ],
            ),
          ),
        ));
  }
}
