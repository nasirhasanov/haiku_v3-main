import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haiku/cubits/login/login_cubit.dart';
import 'package:haiku/presentation/widgets/global/global_input.dart';
import 'package:haiku/utilities/constants/app_texts.dart';
import '../../../../../utilities/extensions/object_extensions.dart';


class LoginPasswordInput extends StatelessWidget {
  const LoginPasswordInput({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();
    return StreamBuilder<String?>(
        initialData: null,
        stream: cubit.passwordStream,
        builder: (context, snapshot) {
          return GlobalInput(
            hintText: AppTexts.password,
            errorText: snapshot.error.valueOrNull,
            isObscure: true,
            onChanged: (v) => cubit.validatePassword(v),
          );
        });
  }
}