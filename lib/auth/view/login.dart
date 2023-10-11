import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:oktoast/oktoast.dart';
import 'package:photo_gallery/auth/domain/app_user.dart';

import '../../DataModel/GlobalDataModel.dart';
import '../../routes.dart';
import '../auth_routes.dart';
import '../services/auth_service.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() {
    // Avoid using private types in public APIs.
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent, title: const Text('Login')),
        body: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 100,
            ),
            const Text(
              'LENZ',
              style: TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.bold,
                color: Color(0xff084470),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
              child: TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
              child: TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
            ),
            Expanded(child: Container()),
            SizedBox(
              width: 120,
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xff084470), width: 4),
                  ),
                  onPressed: _login,
                  child: const Text('login')),
            ),
            SizedBox(
              width: 250,
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white, width: 0),
                  ),
                  onPressed: _signup,
                  child: const Text(
                    'Don\'t have an account? Signup',
                    style: TextStyle(),
                  )),
            ),
            SizedBox(
              height: 100,
            ),
          ],
        )));
  }

  void _signup() async {
    AppUser _appUser = await context.push(AuthRoutes.signup.path) as AppUser;
    loginUser = _appUser;
    _emailController.text = _appUser.email!;
  }

  Future<void> _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    try {
      Map<String, dynamic> data = await GetIt.I.get<AuthService>().signIn(email, password);
      AppUser appUser = data['appUser'];
      loginUser = appUser;
      print(appUser.token);
      showToast(appUser.token ?? 'Token Error');

      if (context.mounted && appUser.token != null) {
        // Navigator.pop(context, appUser);
        httpApi.setToken(appUser.token!);
        context.go(Routes.dash.path);
      }
    } catch (e) {
      showToast('Error logging in');
      return;
    }
    print('login');
  }
}
