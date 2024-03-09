import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haiku/presentation/pages/login/widgets/login_password_input.dart';
import 'package:haiku/presentation/pages/register/widgets/signin_prompt.dart';
import 'package:haiku/presentation/widgets/global/global_loading.dart';
import 'package:haiku/utilities/helpers/go.dart';
import 'package:haiku/utilities/helpers/pager.dart';

import '../../../cubits/login/login_cubit.dart';
import '../../../utilities/constants/app_sized_boxes.dart';
import '../../../utilities/constants/app_texts.dart';
import 'widgets/login_button.dart';
import 'widgets/login_email_input.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loginCubit = context.read<LoginCubit>();

    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          Go.closeAll(context, Pager.home);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User Logged In')),
          );
        } else if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error ?? 'Registration Failed')),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppTexts.signIn),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: BlocBuilder<LoginCubit, LoginState>(
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(
                    flex: 1,
                  ),
                  const LoginEmailInput(),
                  AppSizedBoxes.h8,
                  const LoginPasswordInput(),
                  AppSizedBoxes.h20,
                  SignInPrompt(
                      messageText: AppTexts.dontHaveAnAccount,
                      actionText: AppTexts.signUp,
                      onActionPressed: () {
                        Go.replace(context, Pager.register);
                      }),
                  const Spacer(flex: 2),
                  if (loginCubit.state is LoginLoading)
                    const GlobalLoading()
                  else
                    const LoginButton(),
                  TextButton(
                    onPressed: () => loginCubit.resetPassword(),
                    child: const Text('Reset Password'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
