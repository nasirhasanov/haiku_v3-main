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

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  DeleteAccountPageState createState() => DeleteAccountPageState();
}

class DeleteAccountPageState extends State<DeleteAccountPage> {
  bool _isPosting = false;
  var email = '';
  String _passwordText = '';

  @override
  void initState() {
    super.initState();
    var box = Hive.box(AppKeys.userDataBox);
    email = box.get(AppKeys.email);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AccountCubit>();

    void handleDeleteAccount(BuildContext context) async {
      if (_passwordText.isEmpty && _isPosting) {
        return;
      }
      setState(() {
        _isPosting = true;
      });
      await cubit.deleteAccount(email, _passwordText);
      
      setState(() {
        _isPosting = false;
      });
    }

    return BlocListener<AccountCubit, AccountState>(
      listener: (context, state) {
        if (state is DeleteAccountFailure) {
          Toast.show(state.error ?? AppTexts.anErrorOccurred, context);
        } else if (state is DeleteAccountSuccess) {
          Toast.show(AppTexts.accountDeleted, context);
          Go.back(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppTexts.deleteAccount),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                AppTexts.deleteAccountDescription,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                ),
              ),
              AppSizedBoxes.h16,
              GlobalInput(
                hintText: AppTexts.password,
                isObscure: true,
                onChanged: (text) => {
                  setState(() {
                    _passwordText = text;
                  })
                },
              ),
              const Spacer(),
              if (_isPosting) const GlobalLoading(),
              const Spacer(),
              GlobalButton(
                buttonText: AppTexts.delete,
                isEnabled: _passwordText.isNotEmpty,
                onPressed: () {
                  handleDeleteAccount(context);
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
