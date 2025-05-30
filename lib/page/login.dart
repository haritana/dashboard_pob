import 'dart:developer';

import 'package:dashboard_pob/core/auth.dart';
import 'package:dashboard_pob/page/admin.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  final FocusNode _focusNodeUsername = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 1), end: const Offset(0, 0))
            .animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });

    _focusNodeUsername.addListener(() {
      if (_focusNodeUsername.hasFocus) {
        log("Input is focused username");
      } else {
        log("Input lost focus username");
      }
    });

    _focusNodePassword.addListener(() {
      if (_focusNodePassword.hasFocus) {
        log("Input is focused password");
      } else {
        log("Input lost focus password");
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    usernameController.clear();
    passwordController.clear();
    _focusNodePassword.dispose();
    _focusNodeUsername.dispose();
    super.dispose();
  }

  void _login() async {
    final username = usernameController.text.trim();
    final password = passwordController.text;

    final isValid = await AuthService.verifyCredentials(username, password);

    if (isValid) {
      goTo();
    } else {
      showSnackbarResponse(
        message: 'Login Failed, username or password incorrect',
        color: Colors.red,
      );
    }
  }

  void showSnackbarResponse({required String message, required Color color}) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: color,
        ),
      );

  void goTo() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
      FocusScope.of(context).unfocus();
      return AdminPage();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF090979),
              Color(0xFF22577A),
            ],
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
          ),
        ),
        child: Center(
          child: SizedBox(
            width: 500,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Login',
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    FadeTransition(
                      opacity: _opacityAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: SizedBox(
                          child: Column(
                            children: [
                              SizedBox(
                                child: TextFormField(
                                  controller: usernameController,
                                  focusNode: _focusNodeUsername,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                    labelText: 'Username',
                                    labelStyle: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                    border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.green)),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.green)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.green)),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your username';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    hintStyle: TextStyle(color: Colors.white),
                                    border: const OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.green)),
                                    enabledBorder: const OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.green)),
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.green)),
                                    labelStyle: const TextStyle(
                                        color: Colors.white, fontSize: 12),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isPasswordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isPasswordVisible =
                                              !_isPasswordVisible;
                                        });
                                      },
                                    ),
                                  ),
                                  style: const TextStyle(color: Colors.white),
                                  controller: passwordController,
                                  focusNode: _focusNodePassword,
                                  obscureText: !_isPasswordVisible,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your password';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 50),
                              SizedBox(
                                width: 400,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _login();
                                    }
                                  },
                                  style: const ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                      Colors.green,
                                    ),
                                    shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
