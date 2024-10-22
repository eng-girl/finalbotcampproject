import 'package:finalproject1/presentation/storeownerside/storemain_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../bloc/cubit/auth_cubit.dart';
import '../bloc/state/auth_state.dart';
import '../core/theme/app_colors.dart';
import 'customer_side/cs_main_layout.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formkey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkBackground
            : AppColors.white,
        body: SingleChildScrollView(
          child: Center(
            child: Form(
              key: formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: screenWidth * 0.15, top: screenHeight * 0.02),
                          child: Text(
                            'CarftIt',
                            style: TextStyle(
                              fontFamily: 'Kathen',
                              fontSize: screenWidth * 0.06, // Responsive font size
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? AppColors.darkText
                                  : AppColors.lightText,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: screenWidth * 0.15),
                          child: SvgPicture.asset(
                            'assets/images/logo.svg',
                            width: screenWidth * 0.75, // Responsive image size
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                    child: Focus(
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'لا يمكن أن يكون الحقل فارغ';
                          } else if (RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value)) {
                            return null;
                          } else {
                            return 'البريد الإلكتروني غير صالح';
                          }
                        },
                        textInputAction: TextInputAction.next,
                        controller: emailController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.darkGrey),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          labelText: 'البريد الإلكتروني',
                          labelStyle: TextStyle(
                            fontSize: screenWidth * 0.035, // Responsive font size
                            color: Theme.of(context).brightness == Brightness.dark
                                ? AppColors.darkText
                                : AppColors.lightText,
                          ),
                          prefixIcon: Icon(Icons.email, color: AppColors.darkGrey),
                          contentPadding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                        ),
                        style: TextStyle(fontSize: screenWidth * 0.04),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04,
                      vertical: screenHeight * 0.03,
                    ),
                    child: Focus(
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'لا يمكن أن يكون الحقل فارغ';
                          } else if (!RegExp(r"^[a-zA-Z0-9]{6}$").hasMatch(value)) {
                            return '6 أحرف أو أرقام على الأقل';
                          } else {
                            return null;
                          }
                        },
                        controller: passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.darkGrey),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          labelText: 'كلمة المرور',
                          labelStyle: TextStyle(
                            fontSize: screenWidth * 0.035,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? AppColors.darkText
                                : AppColors.lightText,
                          ),
                          prefixIcon: Icon(Icons.lock, color: AppColors.darkGrey),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                              color: AppColors.darkGrey,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                        ),
                        style: TextStyle(fontSize: screenWidth * 0.04),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.45, bottom: screenHeight * 0.08),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/forgotpass');
                      },
                      child: Text(
                        'نسيت كلمة المرور؟',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: AppColors.primary,
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  BlocConsumer<AuthCubit, AuthState>(
                    listener: (context, state) {
                      if (state is AuthError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.message)),
                        );
                      } else if (state is AuthLoggedIn) {
                        if (state.user.role == 'customer') {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => CSMainLayout()),
                          );
                        } else if (state.user.role == 'store_owner') {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => storemainlayout()),
                          );
                        }
                      }
                    },
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return CircularProgressIndicator(
                          color: AppColors.primary,
                        );
                      }
                      return Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  padding: EdgeInsets.symmetric(
                                      vertical: screenHeight * 0.015, horizontal: screenWidth * 0.04),
                                  backgroundColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(screenWidth * 0.02),
                                  ),
                                ),
                                onPressed: () {
                                  if (formkey.currentState!.validate()) {
                                    context.read<AuthCubit>().login(
                                        emailController.text.trim(),
                                        passwordController.text.trim());
                                  }
                                },
                                child: Text(
                                  'تسجيل الدخول',
                                  style: TextStyle(fontSize: screenWidth * 0.04),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.015,
                              horizontal: screenWidth * 0.04,
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  side: BorderSide(
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? AppColors.darkGrey
                                        : AppColors.black,
                                  ),
                                  elevation: 0,
                                  padding: EdgeInsets.symmetric(
                                      vertical: screenHeight * 0.015, horizontal: screenWidth * 0.04),
                                  backgroundColor: Theme.of(context).brightness == Brightness.dark
                                      ? AppColors.cardsBackgroundDark
                                      : AppColors.cardsBackgroundLight,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(screenWidth * 0.02),
                                  ),
                                ),
                                onPressed: () {},
                                child: Text(
                                  'إنشاء حساب',
                                  style: TextStyle(fontSize: screenWidth * 0.04),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
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
