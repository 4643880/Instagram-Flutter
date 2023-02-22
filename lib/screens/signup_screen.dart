import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter/resources/auth_methods.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/show_snackbar.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:instagram_flutter/widgets/text_field_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  Uint8List? _image;
  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _userNameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void selectImage() async {
    Uint8List? bytesOfImage = await picImage(ImageSource.gallery);
    setState(() {
      _image = bytesOfImage;
    });
  }

  signupUser() async {
    if (_image != null) {
      setState(() {
        isLoading = true;
      });
      final result = await AuthMethods().signupUser(
        context: context,
        email: _emailController.text.trim(),
        password: _passwordController.text,
        username: _userNameController.text.trim(),
        bio: _bioController.text.trim(),
        file: _image!,
      );
      if (result == "success") {
        // ignore: use_build_context_synchronously
        showSnackbar(
          context: context,
          content: "You have Signed Up Successfully...",
        );
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
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
                // Circular Widget to Accept and show selected file
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 64,
                            backgroundImage: MemoryImage(_image!),
                          )
                        : const CircleAvatar(
                            radius: 64,
                            backgroundImage: NetworkImage(
                              "https://static.vecteezy.com/system/resources/thumbnails/009/734/564/small/default-avatar-profile-icon-of-social-media-user-vector.jpg",
                            ),
                          ),
                    Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(
                          Icons.add_a_photo,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                // Input Field For User Name
                TextFieldInput(
                  controller: _userNameController,
                  hintText: "Enter Your User Name",
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(
                  height: 24,
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
                // Input Field For Email
                TextFieldInput(
                  controller: _bioController,
                  hintText: "Please Enter Bio",
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(
                  height: 24,
                ),
                // Login Button
                InkWell(
                  onTap: signupUser,
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
                    child: isLoading == false
                        ? const Text("Sign Up")
                        : const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
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
      ),
    );
  }
}
