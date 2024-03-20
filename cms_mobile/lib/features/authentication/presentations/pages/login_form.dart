import 'package:cms_mobile/core/routes/route_names.dart';
import 'package:cms_mobile/features/authentication/domain/usecases/authentication_usecase.dart';
import 'package:cms_mobile/features/authentication/presentations/bloc/auth/auth_bloc.dart';
import 'package:cms_mobile/features/authentication/presentations/bloc/login/log_in_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _MyLoginFormState();
}

class _MyLoginFormState extends State<LoginForm> {
  late final TextEditingController _phoneNumberController;
  late final TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();
  late MyLoginFormState _loginFormState;

  @override
  void initState() {
    super.initState();
    _loginFormState = const MyLoginFormState();
    _phoneNumberController =
        TextEditingController(text: _loginFormState.phoneNumber.value)
          ..addListener(_onPhoneChange);
    _passwordController =
        TextEditingController(text: _loginFormState.password.value)
          ..addListener(_onPasswordChange);
  }

  @override
  void dispose() {
    // Dispose of the controllers to prevent memory leaks
    _phoneNumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _forgotPassword() {
    context.push(RouteNames.forgotPassword);
  }

  void _onPhoneChange() {
    setState(() {
      _loginFormState = _loginFormState.copyWith(
        phoneNumber: PhoneNumber.dirty(_phoneNumberController.text),
      );
    });
  }

  void _onPasswordChange() {
    setState(() {
      _loginFormState = _loginFormState.copyWith(
        password: Password.dirty(_passwordController.text),
      );
    });
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _loginFormState =
          _loginFormState.copyWith(status: FormzSubmissionStatus.inProgress);
    });

    try {
      await _submitForm();
      _loginFormState =
          _loginFormState.copyWith(status: FormzSubmissionStatus.success);
    } catch (_) {
      _loginFormState =
          _loginFormState.copyWith(status: FormzSubmissionStatus.failure);
    }

    if (!mounted) return;

    setState(() {});

    FocusScope.of(context)
      ..nextFocus()
      ..unfocus();
  }

  Future<void> _submitForm() async {
    context.read<LoginBloc>().add(
          LoginEvent(
            loginParams: LoginParams(
              phoneNumber: _phoneNumberController.text.trim(),
              password: _passwordController.text.trim(),
            ),
          ),
        );

    _resetForm();
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _phoneNumberController.clear();
    _passwordController.clear();
    setState(() => _loginFormState = const MyLoginFormState());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailed) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
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
          context.go(RouteNames.home);
        }
      },
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 30,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Log in to your account',
                  style: TextStyle(
                    color: Color(0xFF111416),
                    fontSize: 30,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Welcome back, please enter your details',
                  style: TextStyle(
                    color: Color(0xFF637587),
                    fontSize: 15,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 0.12,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: TextFormField(
                      controller: _phoneNumberController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 35, 7, 7),
                        fontSize: 15,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFEFF2F4),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 20,
                        ),
                        hintText: "phoneNumberPlaceholder".tr(),
                        focusedBorder: InputBorder.none,
                        border: InputBorder.none,
                      ),
                      // decoration: const InputDecoration(
                      //   filled: true,
                      //   fillColor: Color(0xFFEFF2F4),
                      //   hintText: "passwordPlaceholder".tr(),

                      //   // hintText: "phoneNumberPlaceholder".tr(),
                      //   contentPadding: EdgeInsets.symmetric(
                      //     horizontal: 16,
                      //     vertical: 20,
                      //   ),
                      //   isDense: true,
                      //   focusedBorder: InputBorder.none,
                      //   border: InputBorder.none,
                      // ),

                      validator: (value) => _loginFormState.phoneNumber
                          .validator(value ?? '')
                          ?.text(),
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: TextFormField(
                      controller: _passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      onChanged: (value) {
                        _onPasswordChange();
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFEFF2F4),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 20,
                        ),
                        hintText: "passwordPlaceholder".tr(),
                        focusedBorder: InputBorder.none,
                        border: InputBorder.none,
                      ),
                      validator: (value) => _loginFormState.password
                          .validator(value ?? '')
                          ?.text(),
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
                  if (state is LoginLoading) {
                    return Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 40,
                      padding: const EdgeInsets.all(10),
                      decoration: ShapeDecoration(
                        color: const Color(0xFF1A80E5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Logging in...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              height: 0,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return InkWell(
                    onTap: _onSubmit,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 40,
                      padding: const EdgeInsets.all(10),
                      decoration: ShapeDecoration(
                        color: const Color(0xFF1A80E5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Log in',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              height: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: () {
                    _forgotPassword();
                  },
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(
                      color: Color(0xFF1A80E5),
                      fontSize: 13,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                ),
                Container(
                  width: 24,
                  height: 24,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(),
                  child: const Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: SizedBox(width: 18, height: 15),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyLoginFormState with FormzMixin {
  final PhoneNumber phoneNumber;
  final Password password;
  final FormzSubmissionStatus status;

  const MyLoginFormState(
      {this.phoneNumber = const PhoneNumber.pure(),
      this.password = const Password.pure(),
      this.status = FormzSubmissionStatus.initial});

  MyLoginFormState copyWith({
    PhoneNumber? phoneNumber,
    Password? password,
    FormzSubmissionStatus? status,
  }) {
    return MyLoginFormState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      status: status ?? this.status,
    );
  }

  @override
  List<FormzInput<dynamic, dynamic>> get inputs => [phoneNumber, password];
}

enum PasswordValidationError { invalid, empty }

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure([super.value = '']) : super.pure();

  const Password.dirty([super.value = '']) : super.dirty();

  // static final _passwordRegex =
  //     RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');

  static final _passwordRegex = RegExp(r'');

  @override
  PasswordValidationError? validator(String value) {
    if (value.isEmpty) {
      return PasswordValidationError.empty;
    } else if (!_passwordRegex.hasMatch(value)) {
      return PasswordValidationError.invalid;
    }

    return null;
  }
}

enum PhoneNumberValidationError { invalid, empty }

class PhoneNumber extends FormzInput<String, PhoneNumberValidationError> {
  const PhoneNumber.pure([super.value = '']) : super.pure();

  const PhoneNumber.dirty([super.value = '']) : super.dirty();

  static final _phoneNumberRegex = RegExp(r'');
  // static final _phoneNumberRegex = RegExp(r'^[0-9]{10}$');

  @override
  PhoneNumberValidationError? validator(String value) {
    if (value.isEmpty) {
      return PhoneNumberValidationError.empty;
    } else if (!_phoneNumberRegex.hasMatch(value)) {
      return PhoneNumberValidationError.invalid;
    }

    return null;
  }
}

extension on PhoneNumberValidationError {
  String text() {
    switch (this) {
      case PhoneNumberValidationError.empty:
        return 'Phone number cannot be empty';
      case PhoneNumberValidationError.invalid:
        return 'Invalid phone number';
      default:
        return '';
    }
  }
}

extension on PasswordValidationError {
  String text() {
    switch (this) {
      case PasswordValidationError.empty:
        return 'Password cannot be empty';
      case PasswordValidationError.invalid:
        return 'Invalid password';
      default:
        return '';
    }
  }
}
