import 'package:flutter/material.dart';

import 'package:messaging_app/router/router.dart';

// class Login extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Login Page',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: _Login(),
//     );
//   }
// }

class Login extends StatefulWidget {
  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool _passwordObscured = true;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      print("Email: ${_emailController.text}");
      print("Password: ${_passwordController.text}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Page')),
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
                      onPressed: _submitForm,
                      child: const Text('Login'),
                    ),
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          "Forgot your password?",
                          style: TextStyle(
                            color: Colors.blue, // Change color to mimic a link
                            decoration:
                                TextDecoration.underline, // Add underline
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
                  const Text("Don't have an account? "),
                  GestureDetector(
                    child: const Text("Sing up",
                        style: TextStyle(
                          color: Colors.blue, // Change color to mimic a link
                          decoration: TextDecoration.underline, // Add underline
                        )),
                    onTap: () {
                      print("test");
                      router.go("/register");
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
