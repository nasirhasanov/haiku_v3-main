import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../cubits/register/register_cubit.dart';
import '../../../../../utilities/constants/app_texts.dart';
import '../../../../../utilities/extensions/object_extensions.dart';
import '../../../../widgets/global/global_input.dart';

class RegisterEmailInput extends StatelessWidget {
  const RegisterEmailInput({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RegisterCubit>();
    return StreamBuilder<String?>(
        initialData: null,
        stream: cubit.emailStream,
        builder: (context, snapshot) {
          return GlobalInput(
            hintText: AppTexts.email,
            errorText: snapshot.error.valueOrNull,
            onChanged: (v) => cubit.validateEmail(v),
          );
        });
  }
}
