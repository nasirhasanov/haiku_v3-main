import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haiku/cubits/register/register_cubit.dart';
import 'package:haiku/presentation/widgets/global/global_input.dart';
import '../../../../../utilities/extensions/object_extensions.dart';
import 'package:haiku/utilities/constants/app_texts.dart';

class RegisterPasswordInput extends StatelessWidget {
  const RegisterPasswordInput({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RegisterCubit>();
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