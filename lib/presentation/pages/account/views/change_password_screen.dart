import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haiku/cubits/account/account_cubit.dart';
import 'package:haiku/presentation/widgets/global/global_button.dart';
import 'package:haiku/presentation/widgets/global/global_input.dart';
import 'package:haiku/presentation/widgets/global/global_loading.dart';
import 'package:haiku/utilities/constants/app_keys.dart';
import 'package:haiku/utilities/constants/app_sized_boxes.dart';
import 'package:haiku/utilities/constants/app_texts.dart';
import 'package:haiku/utilities/helpers/go.dart';
import 'package:haiku/utilities/helpers/toast.dart';
import 'package:hive/hive.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  ChangePasswordState createState() => ChangePasswordState();
}

class ChangePasswordState extends State<ChangePasswordPage> {
  bool _isPosting = false;
  var email = '';
  String _oldPasswordText = "";
  String _newPasswordText = "";
  String _newPasswordAgainText = "";

  @override
  void initState() {
    super.initState();
    var box = Hive.box(AppKeys.userDataBox);
    email = box.get(AppKeys.email);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AccountCubit>();

    void handleChangePassword(BuildContext context) async {
      if (_isPosting) {
        return;
      }
      if (_newPasswordText != _newPasswordAgainText) {
        Toast.show(AppTexts.passwordsNotSame, context);
        return;
      }
      setState(() {
        _isPosting = true;
      });
      await cubit.changePassword(
        email,
        _oldPasswordText,
        _newPasswordText,
      );
      setState(() {
        _isPosting = false;
      });
    }

    return BlocListener<AccountCubit, AccountState>(
      listener: (context, state) {
        if (state is ChangePasswordFailure) {
          Toast.show(state.error ?? AppTexts.anErrorOccurred, context);
        } else if (state is ChangePasswordSuccess) {
          Toast.show(AppTexts.passwordChanged, context);
          Go.back(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppTexts.changeBio),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              AppSizedBoxes.h16,
              GlobalInput(
                hintText: AppTexts.oldPassword,
                isObscure: true,
                onChanged: (text) => {
                  setState(() {
                    _oldPasswordText = text;
                  })
                },
              ),
              GlobalInput(
                hintText: AppTexts.newPassword,
                isObscure: true,
                onChanged: (text) => {
                  setState(() {
                    _newPasswordText = text;
                  })
                },
              ),
              GlobalInput(
                hintText: AppTexts.newPasswordAgain,
                isObscure: true,
                onChanged: (text) => {
                  setState(() {
                    _newPasswordAgainText = text;
                  })
                },
              ),
              const Spacer(),
              if (_isPosting) const GlobalLoading(),
              const Spacer(),
              GlobalButton(
                buttonText: AppTexts.change,
                isEnabled: _oldPasswordText.isNotEmpty &&
                    _newPasswordText.isNotEmpty &&
                    _newPasswordAgainText.isNotEmpty,
                onPressed: () {
                  handleChangePassword(context);
                },
              ),
              AppSizedBoxes.h16
            ],
          ),
        ),
      ),
    );
  }
}
