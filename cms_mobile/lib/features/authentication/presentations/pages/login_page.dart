import 'package:cms_mobile/core/colors/colors.dart';
import 'package:cms_mobile/core/routes/route_names.dart';
import 'package:cms_mobile/features/authentication/domain/usecases/authentication_usecase.dart';
import 'package:cms_mobile/features/authentication/presentations/bloc/auth/auth_bloc.dart';
import 'package:cms_mobile/features/authentication/presentations/bloc/login/log_in_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Dispose of the controllers to prevent memory leaks
    _phoneNumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Function to handle form submission
  void _submitForm() {
    if (formKey.currentState!.validate()) {
      context.read<LoginBloc>().add(
            LoginEvent(
              loginParams: LoginParams(
                phoneNumber: _phoneNumberController.text.trim(),
                password: _passwordController.text.trim(),
              ),
            ),
          );
    }
  }

  void _forgotPassword() {
    context.push(RouteNames.forgotPasswordRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.backgroundColor,
      body: BlocListener<LoginBloc, LoginFormState>(
        listener: (context, state) {
          if (state is LoginFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.error!.errorMessage,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                duration: const Duration(seconds: 2),
              ),
            );
          } else if (state is LoginSuccess) {
            // update the auth state
            context.read<AuthBloc>().add(AuthIsSignedIn());
            debugPrint('LoginSuccess: ${state.login!.accessToken}');
            context.go(RouteNames.homePage);
          }
        },
        child: SafeArea(
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 30,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "login".tr(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      // Phone number input field
                      TextFormField(
                        controller: _phoneNumberController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: "phoneNumberLabel".tr(),
                          hintText: "phoneNumberPlaceholder".tr(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "phoneNumberError".tr();
                          }
                          return null;
                        },
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      // Password input field

                      TextFormField(
                        controller: _passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "passwordLabel".tr(),
                          hintText: "passwordPlaceholder".tr(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "passwordError".tr();
                          }
                          return null;
                        },
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      // Forgot password button

                      TextButton(
                        onPressed: _forgotPassword,
                        child: Text(
                          "${"forgotPassword".tr()}?",
                          style: const TextStyle(
                              color: ThemeColors.primary,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  BlocBuilder<LoginBloc, LoginFormState>(
                    builder: (context, state) {
                      if (state is LoginLoading) {
                        return const CircularProgressIndicator();
                      }

                      return ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "loginButton".tr(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    },
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "dontHaveAccount".tr(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: ThemeColors.termsAndConditionsColor,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.go(RouteNames.signupRoute);
                        },
                        child: Text(
                          "signup".tr(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: ThemeColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
