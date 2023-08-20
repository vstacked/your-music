import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:your_music/constants/colors.dart';
import 'package:provider/provider.dart';
import 'package:your_music/providers/auth_provider.dart';
import 'package:your_music/widgets/base_field.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  late final AuthProvider _authProvider;

  @override
  void initState() {
    super.initState();
    _authProvider = context.read<AuthProvider>();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Center(
        child: SizedBox(
          // TODO (value?)
          height: 491,
          width: 475,
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: primaryColor,
            child: Padding(
              // TODO (value?)
              padding: const EdgeInsets.symmetric(horizontal: 51),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    const Spacer(),
                    Text(
                      'Your Music',
                      style: textTheme.headlineMedium!.copyWith(color: greyColor),
                    ),
                    const Spacer(),
                    BaseField(
                      title: 'Username',
                      onChanged: (value) {
                        _authProvider
                          ..setFormValidated(_formKey.currentState!.validate())
                          ..username = value;
                      },
                      onSubmitted: (_) => login(),
                    ),
                    const SizedBox(height: 10),
                    BaseField(
                      title: 'Password',
                      isPassword: true,
                      onChanged: (value) {
                        _authProvider
                          ..setFormValidated(_formKey.currentState!.validate())
                          ..password = value;
                      },
                      onSubmitted: (_) => login(),
                    ),
                    const SizedBox(height: 30),
                    Selector<AuthProvider, String>(
                      selector: (_, provider) => provider.errorMessage,
                      builder: (_, value, __) => Text(
                        value,
                        style: textTheme.bodyLarge!.copyWith(color: redColor),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Selector<AuthProvider, dartz.Tuple2<bool, bool>>(
                      selector: (_, provider) => dartz.Tuple2(
                        provider.isValidated,
                        provider.isLoading,
                      ),
                      builder: (_, tuple, __) => ElevatedButton(
                        onPressed: tuple.value1 ? login : null,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(blueColor),
                          fixedSize:
                              // TODO (value?)
                              MaterialStateProperty.all(const Size(169, 56)),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          elevation: MaterialStateProperty.all(0),
                        ),
                        child: _TextButton(isLoading: tuple.value2),
                      ),
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

  void login() async {
    final success = await _authProvider.login();
    if (context.mounted && success) Navigator.pop(context);
  }
}

class _TextButton extends StatelessWidget {
  final bool isLoading;

  const _TextButton({Key? key, required this.isLoading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isLoading) {
      return Text(
        'Login',
        style: Theme.of(context).textTheme.labelLarge!.copyWith(fontSize: 17, color: greyColor),
      );
    }

    return const SizedBox(
      height: 25,
      width: 25,
      child: CircularProgressIndicator(),
    );
  }
}
