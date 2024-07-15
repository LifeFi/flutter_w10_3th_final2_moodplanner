import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_w10_3th_final2_moodplanner/constants/gaps.dart';
import 'package:flutter_w10_3th_final2_moodplanner/constants/sizes.dart';
import 'package:flutter_w10_3th_final2_moodplanner/features/authentication/view_models/email_sign_up_view_model.dart';
import 'package:flutter_w10_3th_final2_moodplanner/features/authentication/views/login_screen.dart';
import 'package:flutter_w10_3th_final2_moodplanner/features/common/widgets/big_button.dart';

import 'package:go_router/go_router.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  static const String routeName = "signup";
  static const String routeURL = "/signup";
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends ConsumerState<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, String> formData = {};
  bool _autoValidate = false;

  void _onScaffoldTap() {
    FocusScope.of(context).unfocus();
  }

  bool _emailValidator() {
    if (formData["email"] == null) return false;
    if (formData["email"]!.isNotEmpty) return true;

    return false;
  }

  bool _passwordValidator() {
    if (formData["password"] == null) return false;
    if (formData["password"]!.length > 7) return true;

    return false;
  }

  void _onSignUpTap() {
    setState(() {
      _autoValidate = true;
    });

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }

    print(formData);

    ref.read(emailSignUpProvider.notifier).emailSignUp(
          email: formData["email"]!,
          password: formData["password"]!,
          context: context,
        );

    setState(() {
      _autoValidate = false;
    });
  }

  void _goToLogin() {
    context.goNamed(LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onScaffoldTap,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Mood Planner",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.size60,
          ),
          child: Stack(
            children: [
              Form(
                key: _formKey,
                autovalidateMode: _autoValidate
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                child: ListView(
                  children: [
                    Gaps.v10,
                    Center(
                      child: Text("이 앱이 기분을 바꿉니다",
                          style: TextStyle(
                            fontSize: Sizes.size20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade500,
                          ),
                          textAlign: TextAlign.center),
                    ),
                    Gaps.v60,
                    const Center(
                      child: Text(
                        "계정 만들기",
                        style: TextStyle(
                          fontSize: Sizes.size20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Gaps.v32,
                    SizedBox(
                      height: Sizes.size52,
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.only(
                            left: Sizes.size16,
                            top: Sizes.size10,
                          ),
                          hintText: "이메일",
                          hintStyle: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(Sizes.size28),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(Sizes.size28),
                          ),
                        ),
                        validator: (value) {
                          if (_autoValidate) {
                            if (value == null || value.isEmpty) {
                              return "Please write your email";
                            }
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          if (newValue != null) {
                            formData["email"] = newValue;
                          }
                        },
                        onChanged: (value) {
                          setState(() {
                            formData["email"] = value;
                          });
                        },
                      ),
                    ),
                    Gaps.v14,
                    SizedBox(
                      height: Sizes.size52,
                      child: TextFormField(
                        textInputAction: TextInputAction.go,
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "비밀번호",
                          hintStyle: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(Sizes.size28),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(Sizes.size28),
                          ),
                        ),
                        validator: (value) {
                          if (_autoValidate) {
                            if (!_passwordValidator()) {
                              return "Please write your password";
                            }
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          if (newValue != null) {
                            formData["password"] = newValue;
                          }
                        },
                        onChanged: (value) {
                          setState(() {
                            formData["password"] = value;
                          });
                        },
                        onFieldSubmitted: (value) => _onSignUpTap(),
                      ),
                    ),
                    Gaps.v20,
                    BigButton(
                      text: "계정 만들기",
                      fn: _onSignUpTap,
                      color: Theme.of(context).highlightColor,
                      enabled: _emailValidator() && _passwordValidator(),
                      isLoading: ref.watch(emailSignUpProvider).isLoading,
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: Sizes.size40,
                left: 0,
                right: 0,
                height: Sizes.size80,
                child: BigButton(
                  text: "로그인 →",
                  fn: _goToLogin,
                  color: Theme.of(context).highlightColor,
                ),
              )
            ],
          ),
        ),
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}
