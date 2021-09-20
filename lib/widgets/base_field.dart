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
  }) : super(key: key);
  final String title;
  final bool isPassword;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? errorMessage;

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
        Text(widget.title, style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 17, color: greyColor)),
        const SizedBox(height: 9),
        SizedBox(
          height: 75,
          child: TextFormField(
            obscureText: isObscure && widget.isPassword,
            controller: widget.controller,
            onChanged: widget.onChanged,
            onFieldSubmitted: widget.onSubmitted,
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
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return '${widget.title} cannot be empty';
              } else if (widget.isPassword && value.length < 4) {
                return 'Password must be at least 4 characters long';
              } else {
                return null;
              }
            },
          ),
        )
      ],
    );
  }
}
