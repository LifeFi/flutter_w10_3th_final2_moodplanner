import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_w10_3th_final2_moodplanner/constants/gaps.dart';
import 'package:flutter_w10_3th_final2_moodplanner/constants/sizes.dart';
import 'package:flutter_w10_3th_final2_moodplanner/features/authentication/view_models/email_login_view_model.dart';
import 'package:flutter_w10_3th_final2_moodplanner/features/authentication/views/sign_up_screen.dart';
import 'package:flutter_w10_3th_final2_moodplanner/features/common/widgets/big_button.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const String routeName = "login";
  static const String routeURL = "/login";

  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends ConsumerState<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;

  Map<String, String> formData = {};
  bool _autoValidate = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(
        // text: ref.read(recentLoginEmailProvider)
        );

    formData["email"] = _emailController.text;
  }

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

  void _onLoginTap() {
    setState(() {
      _autoValidate = true;
    });

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }

    print(formData);

    ref.read(emailLoginProvider.notifier).emailLogin(
          email: formData["email"]!,
          password: formData["password"]!,
          context: context,
        );

    setState(() {
      _autoValidate = false;
    });
  }

  void _goToLogin() {
    context.goNamed(SignUpScreen.routeName);
  }

  _onClearEmailTap() {
    formData["email"] = "";
    _emailController.text = "";
    // ref.read(recentLoginEmailProvider.notifier).resetLoginEmail("");
    setState(() {});
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
                      child: Text(
                        "기분을 디자인하세요~",
                        style: TextStyle(
                          fontSize: Sizes.size20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Gaps.v60,
                    const Center(
                      child: Text(
                        "로그인",
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
                        controller: _emailController,
                        textInputAction: TextInputAction.next,
                        // autofocus: true,
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
                          suffix: _emailController.text.isNotEmpty
                              ? GestureDetector(
                                  onTap: _onClearEmailTap,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      right: Sizes.size10,
                                    ),
                                    child: FaIcon(
                                      FontAwesomeIcons.solidCircleXmark,
                                      color: Colors.grey.withOpacity(0.7),
                                      size: Sizes.size20,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                        //  onTap: () => _formKey.currentState!.save(),
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
                        onFieldSubmitted: (value) => _onLoginTap(),
                      ),
                    ),
                    Gaps.v20,
                    BigButton(
                      text: "로그인",
                      fn: _onLoginTap,
                      color: Theme.of(context).highlightColor,
                      enabled: _emailValidator() && _passwordValidator(),
                      isLoading: ref.watch(emailLoginProvider).isLoading,
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
                  text: "계정 만들기 →",
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
