import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haiku/cubits/user/profile_cubit.dart';
import 'package:haiku/presentation/widgets/global/global_button.dart';
import 'package:haiku/presentation/widgets/global/global_loading.dart';
import 'package:haiku/utilities/constants/app_keys.dart';
import 'package:haiku/utilities/constants/app_sized_boxes.dart';
import 'package:haiku/utilities/constants/app_texts.dart';
import 'package:haiku/utilities/helpers/go.dart';
import 'package:haiku/utilities/helpers/toast.dart';
import 'package:hive/hive.dart';

class ChangeBioPage extends StatefulWidget {
  const ChangeBioPage({super.key});

  @override
  ChangeBioPageState createState() => ChangeBioPageState();
}

class ChangeBioPageState extends State<ChangeBioPage> {
  late TextEditingController _controller;
  bool _isPosting = false;
  var currentBio = '';
  String _text = "";

  @override
  void initState() {
    super.initState();
    var box = Hive.box(AppKeys.userDataBox);
    currentBio = box.get(AppKeys.bio);
    _controller = TextEditingController(text: currentBio);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileCubit>();

    void handleChangeBio(BuildContext context) async {
      String _text = _controller.text.trim();
      if (_text.isEmpty && _isPosting) {
        return;
      }
      setState(() {
        _isPosting = true;
      });
      bool? success = await cubit.changeBio(_text);
      setState(() {
        _isPosting = false;
      });

      if (success == true) {
        Toast.show(AppTexts.bioChanged, context);
        Go.back(context);
      } else {
        Toast.show(AppTexts.failedChangeBio, context);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppTexts.changeBio),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            AppSizedBoxes.h16,
            TextField(
              controller: _controller,
              maxLength: 40,
               onChanged: (text) => {
                setState(() {
                  _text = text;
                })
              },
            ),
            const Spacer(),
            if (_isPosting) const GlobalLoading(),
            const Spacer(),
            GlobalButton(
              buttonText: AppTexts.change,
              isEnabled: _text.isNotEmpty && _text != currentBio,
              onPressed: () {
                handleChangeBio(context);
              },
            ),
            AppSizedBoxes.h16
          ],
        ),
      ),
    );
  }
}
