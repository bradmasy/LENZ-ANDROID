import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() {
    // Avoid using private types in public APIs.
    return _SignupState();
  }
}

class _SignupState extends State<Signup> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();
  String _emailAlert = '';
  String _passwordAlert = '';
  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      if (!validateEmail(_emailController.text)) {
        print('invalid email');
        if (_emailController.text.isNotEmpty) {
          _emailAlert = 'Invalid email';
        }
      } else {
        _emailAlert = '';
      }
      setState(() {});
    });

    _passwordConfirmController.addListener(() {
      if (_passwordConfirmController.text != _passwordController.text && _passwordConfirmController.text.isNotEmpty) {
        _passwordAlert = 'Passwords do not match';
        setState(() {});
      } else {
        _passwordAlert = '';
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent, title: const Text('Signup')),
        body: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'LENZ',
              style: TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.bold,
                color: Color(0xff084470),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10, left: 20, right: 20, top: 10),
              child: TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
            ),
            _emailAlert.isNotEmpty
                ? Container(
                    margin: const EdgeInsets.only(bottom: 0, left: 20, right: 20),
                    child: Text(
                      _emailAlert,
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  )
                : Container(),
            Container(
              margin: const EdgeInsets.only(bottom: 10, left: 20, right: 20, top: 10),
              child: TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10, left: 20, right: 20, top: 10),
              child: TextField(
                controller: _passwordConfirmController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Confirm password',
                ),
              ),
            ),
            _passwordAlert.isNotEmpty
                ? Container(
                    margin: const EdgeInsets.only(bottom: 0, left: 20, right: 20),
                    child: Text(
                      _passwordAlert,
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  )
                : Container(),
            SizedBox(
              height: 20,
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
                  onPressed: () {
                    _Signup();
                  },
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Color(0xff084470),
                    ),
                  )),
            ),
            SizedBox(
              height: 100,
            ),
          ],
        )));
  }

  Future<void> _Signup() async {
    if (_passwordAlert.isNotEmpty || _emailAlert.isNotEmpty) {
      return;
    }

    try {
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
    }
  }

  bool validateEmail(String value) {
    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  bool validatePassword(String value) {
    return value.length > 5;
  }
}
