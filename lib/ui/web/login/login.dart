import 'package:flutter/material.dart';
import 'package:your_music/constants/colors.dart';
import 'package:provider/provider.dart';
import 'package:your_music/providers/auth_provider.dart';
import 'package:your_music/widgets/base_field.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;
  late final AuthProvider _authProviderRead;

  @override
  void initState() {
    super.initState();
    _authProviderRead = context.read<AuthProvider>();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 491,
          width: 475,
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: primaryColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 51),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    const Spacer(),
                    Text(
                      'This is Logo',
                      style: textTheme.headline4!.copyWith(color: greyColor),
                    ),
                    const Spacer(),
                    BaseField(
                      title: 'Username',
                      controller: _usernameController,
                      onChanged: (_) {
                        _formKey.currentState!.validate();
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 10),
                    BaseField(
                      title: 'Password',
                      isPassword: true,
                      controller: _passwordController,
                      onChanged: (_) {
                        _formKey.currentState!.validate();
                        setState(() {});
                      },
                      onSubmitted: (_) {
                        if (_formKey.currentState!.validate()) {
                          _authProviderRead.login(context, _usernameController.text, _passwordController.text);
                        }
                      },
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: (_usernameController.text.isNotEmpty && _passwordController.text.isNotEmpty)
                          ? () {
                              if (_formKey.currentState!.validate()) {
                                _authProviderRead.login(context, _usernameController.text, _passwordController.text);
                              }
                            }
                          : null,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(blueColor),
                        fixedSize: MaterialStateProperty.all(const Size(169, 56)),
                        shape:
                            MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      ),
                      child: Text('Login', style: textTheme.button!.copyWith(fontSize: 17, color: greyColor)),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
