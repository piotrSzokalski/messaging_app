import 'package:flutter/material.dart';

import 'package:messaging_app/router/router.dart';
import 'package:messaging_app/services/auth_service.dart';
import 'package:provider/provider.dart';

import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool _passwordObscured = true;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    print("Email: ${_emailController.text}");
    print("Password: ${_passwordController.text}");
    final authService = Provider.of<AuthService>(context, listen: false);

    FirebaseAuth.instance.idTokenChanges().listen((event) {
      router.goNamed("home");
    });

    try {
      if (_isEmailValid(_emailController.text)) {
        await authService.singInWithEmailAndPassword(
            _emailController.text, _passwordController.text);
      } else {
        await authService.singInWithUsernameAndPassword(
            _emailController.text, _passwordController.text);
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  bool _isEmailValid(String email) {
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    return emailRegExp.hasMatch(email);
  }

  _openPasswordRester(BuildContext context) {
    showDialog(
        context: context,
        builder: (builder) {
          return StatefulBuilder(builder: (context, setStateInDialog) {
            return AlertDialog(
              title: const Text("Password rest"),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                if (_emailController.text.isNotEmpty)
                  Text(
                      "We will send password reset email to: ${_emailController.text}")
                else
                  Column(children: [
                    const Text('Enter your email here'),
                    TextField(
                      controller: _emailController,
                    ),
                  ]),
              ]),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("cancel")),
                ElevatedButton(
                    onPressed: () async {
                      try {
                        await Provider.of<AuthService>(context, listen: false)
                            .resetPassword(_emailController.text);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                                "Password reset link was sent to your email")));
                      } catch (e) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Couldn't send reset link $e")));
                      }
                    },
                    child: Text('Rest'))
              ],
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration:
                          const InputDecoration(labelText: 'Username or Email'),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _passwordObscured,
                      decoration: InputDecoration(
                          labelText: 'Password',
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _passwordObscured = !_passwordObscured;
                                });
                              },
                              icon: Icon(_passwordObscured
                                  ? Icons.visibility
                                  : Icons.visibility_off))),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24.0),
                    ElevatedButton(
                      onPressed: _login,
                      child: const Text('Login'),
                    ),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: GestureDetector(
                          onTap: () => _openPasswordRester(context),
                          child: const Text(
                            "Forgot your password?",
                            style: TextStyle(
                              color:
                                  Colors.blue, // Change color to mimic a link
                              decoration:
                                  TextDecoration.underline, // Add underline
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(fontSize: 18),
                  ),
                  GestureDetector(
                    child: const Text("Sing up",
                        style: TextStyle(
                          color: Colors.blue, // Change color to mimic a link
                          decoration: TextDecoration.underline, // Add underline
                          fontSize: 18,
                        )),
                    onTap: () {
                      print("sing up button pressed");
                      router.goNamed("register");
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
