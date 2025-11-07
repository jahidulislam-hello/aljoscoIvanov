import 'package:flutter/material.dart';
import 'package:freshbite/core/themes/app_images.dart';
import 'package:freshbite/core/widgets/custom_text_button.dart';
import 'package:freshbite/core/widgets/custom_text_field.dart';
import 'package:freshbite/features/auth/sign_in/signin_controller/signin_controller.dart';
import 'package:get/get.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/widgets/button.dart';

import '../../sign_up/signup_screen/signup_screen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController _controller = Get.put(LoginController());

  bool rememberMe = false;

  @override
  void initState() {
    super.initState();

    _controller.emailController.addListener(() {
      final isValid = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$")
          .hasMatch(_controller.emailController.text.trim());
      _controller.isEmailValid.value = isValid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ListView(
          children: [
            const SizedBox(height: 60),

            /// App icon under AppBar
            Center(
              child: Image.asset(
                "assets/images/g10.png",
                height: 100,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),

            Align(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    "Log In",
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Enter your email and password to continue",
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),


            const SizedBox(height: 10),


            /// Email Field
            CustomTextField(
              controller: _controller.emailController,
              hintText: "Email",
              keyboardType: "email",

            ),
            const SizedBox(height: 16),

            /// Password Field
            CustomTextField(
              controller: _controller.passwordController,
              hintText: "Password",
              keyboardType: "visiblePassword",

            ),
            const SizedBox(height: 16),

            /// Remember Me + Forgot Password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Theme(
                      data: Theme.of(context).copyWith(
                        unselectedWidgetColor: Colors.white,
                      ),
                      child: Checkbox(
                        value: rememberMe,
                        onChanged: (value) {
                          setState(() {
                            rememberMe = value ?? false;
                          });
                        },
                        activeColor: AppColors.defaultTextColor, // background when checked
                        checkColor: Colors.white,           // tick color
                      ),
                    ),

                    const Text(
                      "Remember Me",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
                TextButton(

                  onPressed: () {  },
                  child:  Text(
                    'Forgot Password?',
                    style: TextStyle(color: AppColors.defaultTextColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            /// Login Button
            CustomTextButton(
              text: "Log In",
              onTap: (
              ){},

            ),
            const SizedBox(height: 20),

            /// Don’t have an account? Register
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don’t have an account? ",
                  style: TextStyle(color: Colors.white70),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => SignUpScreen());
                  },
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      color: AppColors.defaultTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}