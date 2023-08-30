import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messaging_app/services/auth_service.dart';
import 'package:provider/provider.dart';

import '../router/router.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  bool _passwordObscured = true;
  bool _confirmPasswordObscured = true;
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    FirebaseAuth.instance.idTokenChanges().listen((event) {
      router.goNamed("home");
    });

    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.register(_usernameController.text,
          _emailController.text, _passwordController.text);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Register')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextFormField(
                      controller: _usernameController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'Username'),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your usenamne';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'Email'),
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
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _confirmPasswordObscured,
                      decoration: InputDecoration(
                          labelText: 'Password',
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _confirmPasswordObscured =
                                      !_confirmPasswordObscured;
                                });
                              },
                              icon: Icon(_confirmPasswordObscured
                                  ? Icons.visibility
                                  : Icons.visibility_off))),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please repeat the password';
                        }
                        if (_passwordController.text !=
                            _confirmPasswordController.text) {
                          return 'Passwords do not mach';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24.0),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Register'),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      );
}
