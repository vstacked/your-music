import 'package:flutter/material.dart';
import 'package:your_music/constants/colors.dart';
import 'package:provider/provider.dart';
import 'package:your_music/providers/auth_provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 491,
          width: 475,
          child: Card(
            color: primaryColor,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 45),
                Text(
                  'This is Logo',
                  style: Theme.of(context).textTheme.headline4!.copyWith(color: greyColor),
                ),
                const SizedBox(height: 55),
                _field('Username', controller: _usernameController),
                const SizedBox(height: 20),
                _field('Password', isPassword: true, controller: _passwordController),
                const SizedBox(height: 44),
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthProvider>().login(_usernameController.text, _passwordController.text);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(blueColor),
                    fixedSize: MaterialStateProperty.all(const Size(169, 56)),
                  ),
                  child: const Text('Login'),
                ),
                const SizedBox(height: 63),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(String title, {bool isPassword = false, required TextEditingController controller}) {
    final isObscured = context.watch<AuthProvider>().isObscured;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 51),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 17, color: greyColor)),
          const SizedBox(height: 9),
          SizedBox(
            height: 49,
            child: TextFormField(
              obscureText: isObscured && isPassword,
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: greyColor, width: 2),
                ),
                suffixIcon: (isPassword)
                    ? Transform.scale(
                        scale: .5,
                        child: IconButton(
                          onPressed: context.read<AuthProvider>().togglePassword,
                          icon: isObscured ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                          iconSize: 48,
                          padding: EdgeInsets.zero,
                        ),
                      )
                    : null,
              ),
            ),
          )
        ],
      ),
    );
  }
}
