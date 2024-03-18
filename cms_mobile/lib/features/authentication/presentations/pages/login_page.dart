import 'package:cms_mobile/core/colors/colors.dart';
import 'package:cms_mobile/features/authentication/presentations/pages/login_form.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: ThemeColors.backgroundColor,
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: SafeArea(
          child: LoginForm(),
        ),
      ),
    );
  }
}
