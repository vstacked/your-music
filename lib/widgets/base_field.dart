import 'package:flutter/material.dart';
import 'package:your_music/constants/colors.dart';

class BaseField extends StatefulWidget {
  const BaseField({
    Key? key,
    required this.title,
    this.isPassword = false,
    this.onSubmitted,
    this.controller,
    this.errorMessage,
    this.onChanged,
    this.isTextArea = false,
    this.isOptional = false,
    this.initialValue,
  }) : super(key: key);
  final String title;
  final bool isPassword;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? errorMessage;
  final bool isTextArea;
  final bool isOptional;
  final String? initialValue;

  @override
  _BaseFieldState createState() => _BaseFieldState();
}

class _BaseFieldState extends State<BaseField> {
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title, style: Theme.of(context).textTheme.subtitle1!.copyWith(color: greyColor)),
        const SizedBox(height: 10),
        TextFormField(
          obscureText: isObscure && widget.isPassword,
          controller: widget.controller,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          maxLines: widget.isTextArea ? 5 : 1,
          initialValue: widget.initialValue,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: greyColor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: redColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: greyColor, width: 2),
            ),
            errorText: widget.errorMessage,
            suffixIcon: (widget.isPassword)
                ? Transform.scale(
                    scale: .5,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          isObscure = !isObscure;
                        });
                      },
                      icon: isObscure ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                      iconSize: 48,
                      padding: EdgeInsets.zero,
                    ),
                  )
                : null,
            isDense: true,
          ),
          validator: (value) {
            if (widget.isOptional) return null;
            if (value!.isEmpty) {
              return '${widget.title} cannot be empty';
            } else if (widget.isPassword && value.length < 4) {
              return 'Password must be at least 4 characters long';
            } else {
              return null;
            }
          },
        )
      ],
    );
  }
}
