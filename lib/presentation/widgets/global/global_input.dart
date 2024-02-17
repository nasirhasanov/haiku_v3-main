import 'package:flutter/material.dart';
import '../../../utilities/constants/app_colors.dart';

class GlobalInput extends StatefulWidget {
  const GlobalInput({
    super.key,
    this.labelText,
    this.errorText,
    this.hintText,
    this.isObscure = false,
    this.icon,
    this.onChanged,
  });

  final String? labelText;
  final String? errorText;
  final String? hintText;
  final bool isObscure;
  final Widget? icon;
  final void Function(String)? onChanged;

  @override
  _GlobalInputState createState() => _GlobalInputState();
}

class _GlobalInputState extends State<GlobalInput> {
  late bool _isObscure;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.isObscure;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          onChanged: widget.onChanged,
          obscureText: _isObscure,
          decoration: InputDecoration(
            labelText: widget.labelText,
            hintText: widget.hintText,
            suffixIcon: widget.isObscure
                ? IconButton(
                    icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  )
                : widget.icon,
          ),
        ),
        if (widget.errorText != null) ...[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.errorText!,
              style: const TextStyle(color: AppColors.red),
            ),
          ),
        ],
      ],
    );
  }
}
