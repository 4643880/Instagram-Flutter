import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/widgets/text_field_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 1,
                child: Container(),
              ),
              // Svg Image
              SvgPicture.asset(
                "assets/ic_instagram.svg",
                height: 64,
                colorFilter: const ColorFilter.mode(
                  primaryColor,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(
                height: 64,
              ),
              // Input Field For Email
              TextFieldInput(
                controller: _emailController,
                hintText: "Please Enter Email",
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 24,
              ),
              // Input Field For Password
              TextFieldInput(
                controller: _passwordController,
                hintText: "Enter Your Password",
                obscureText: true,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(
                height: 24,
              ),
              // Login Button
              InkWell(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                  ),
                  decoration: const ShapeDecoration(
                    color: blueColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                  ),
                  child: const Text("Login"),
                ),
              ),
              const SizedBox(
                height: 12,
              ),

              Flexible(
                flex: 1,
                child: Container(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                    child: const Text("Don't have an account? "),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                      child: const Text(
                        "SIGNUP",
                        style: TextStyle(
                            color: blueColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              // Transitioning to Signup
            ],
          ),
        ),
      ),
    );
  }
}
