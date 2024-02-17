import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haiku/utilities/extensions/object_extensions.dart';

import '../../../../../cubits/register/register_cubit.dart';
import '../../../../../utilities/constants/app_texts.dart';
import '../../../../widgets/global/global_input.dart';

class RegisterUsernameInput extends StatelessWidget {
  const RegisterUsernameInput({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RegisterCubit>();
    return StreamBuilder<String?>(
        initialData: null,
        stream: cubit.usernameStream,
        builder: (context, snapshot) {
          return GlobalInput(
            hintText: AppTexts.username,
            errorText: snapshot.error.valueOrNull,
            icon: snapshot.data != null
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : const Icon(Icons.error_outline, color: Colors.red),
            onChanged: (v) => cubit.isUsernameExists(v),
          );
        });
  }
}
