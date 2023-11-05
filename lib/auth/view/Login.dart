import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:oktoast/oktoast.dart';
import 'package:photo_gallery/auth/domain/AppUser.dart';

import '../../DataModel/GlobalDataModel.dart';
import '../../routes.dart';
import '../AuthRoutes.dart';
import '../services/AuthService.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
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
      appBar: AppBar(actions: [
        TextButton(
          child: const Text('*'),
          onPressed: () {
            //random choose a number from 1 and 2
            int random = (1 + Random().nextInt(2));
            if (random == 1) {
              _emailController.text = '1@1.ca';
              _passwordController.text = '1';
            } else {
              _emailController.text = '2@2.ca';
              _passwordController.text = '2';
            }
            showToast('Start auto logging in');
            Future.delayed(const Duration(seconds: 1), () {
              _login().then((value) {
                showToast('Auto logging in complete');
              });
            });
          },
        )
      ], backgroundColor: Colors.transparent, title: const Text('Login')),
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
            Expanded(
              flex: 2,
              child: Container(),
            ),
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
            Expanded(
              flex: 1,
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }

  void _signup() async {
    AppUser appUser = await context.push(AuthRoutes.signup.path) as AppUser;
    loginUser = appUser;
    _emailController.text = appUser.email!;
  }

  Future<void> _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    try {
      Map<String, dynamic> data =
          await GetIt.I.get<AuthService>().signIn(email, password);
      AppUser appUser = data['appUser'];
      loginUser = appUser;
      // showToast(appUser.token ?? 'Token Error');

      if (context.mounted && appUser.token != null) {
        // Navigator.pop(context, appUser);
        httpApi.setToken(appUser.token!);
        context.go(Routes.dash.path);
      }
    } catch (e) {
      showToast('Error logging in');
      return;
    }
  }
}
