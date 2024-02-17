import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../cubits/login/login_cubit.dart';
import '../../../../utilities/constants/app_texts.dart';
import '../../../../utilities/extensions/object_extensions.dart';
import '../../../widgets/global/global_input.dart';

class LoginEmailInput extends StatelessWidget {
  const LoginEmailInput({super.key});

  @override
  Widget build(BuildContext context) {
    final loginCubit = context.read<LoginCubit>();
    return StreamBuilder<String?>(
        initialData: null,
        stream: loginCubit.emailStream,
        builder: (context, snapshot) {
          return GlobalInput(
            hintText: AppTexts.email,
            errorText: snapshot.error.valueOrNull,
            onChanged: (v) => loginCubit.validateEmail(v),
          );
        });
  }
}