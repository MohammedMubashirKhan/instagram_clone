import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instragran_clone/providers/user_provider.dart';
import 'package:instragran_clone/resources/auth_methods.dart';
import 'package:instragran_clone/screens/login_screen.dart';
import 'package:instragran_clone/utils/utils.dart';
import 'package:provider/provider.dart';
import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';
import '../utils/colors.dart';
import '../widgets/text_field_input.dart';
import 'login_screen_const.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _profileImage;
  bool _isloading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void signUpUser() async {
    setState(() {
      _isloading = true;
    });

    AuthMethods auth = AuthMethods();
    List data = await auth.signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      file: _profileImage!,
    );
    String res = data[1];

    setState(() {
      _isloading = false;
    });
    if (res == "success") {
      // save data in user provider
      Provider.of<UserProvider>(context, listen: false).saveData(data[0]);
      print(data[0].username);

      // navigate to home screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          ),
        ),
      );
    } else {
      showSnackBar(res, context);
    }
    print(res);
  }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _profileImage = img;
    });
  }

  navigateToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: body_horizontal_padding),
          width: body_width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Container(
                    // color: mobileBackgroundColor,
                    ),
                flex: 1,
              ),

              // svg image of Instagram
              SvgPicture.asset(
                "assets/ic_instagram.svg",
                color: primaryColor,
                height: svg_height,
              ),
              const SizedBox(
                height: 25,
              ),

              // Circular Avatar
              Stack(
                children: [
                  _profileImage != null
                      ? CircleAvatar(
                          backgroundImage: MemoryImage(_profileImage!),
                          radius: 45,
                        )
                      : const CircleAvatar(
                          backgroundImage: NetworkImage(
                              "https://image.shutterstock.com/image-vector/user-login-authenticate-icon-human-260nw-1365533969.jpg"),
                          radius: 45,
                        ),
                  Positioned(
                    bottom: 0,
                    left: 50,
                    child: IconButton(
                      onPressed: () {
                        selectImage();
                      },
                      icon: const Icon(Icons.add_a_photo),
                      color: Colors.black,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 24,
              ),

              // text field input for username
              TextFieldInput(
                textEditingController: _usernameController,
                hintText: "Enter Yout username",
                textInputType: TextInputType.text,
              ),
              const SizedBox(
                height: 24,
              ),

              // text field input for email
              TextFieldInput(
                textEditingController: _emailController,
                hintText: "Enter Yout Email",
                textInputType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 24,
              ),

              // text field input for password
              TextFieldInput(
                textEditingController: _passwordController,
                ispass: true,
                hintText: "Enter Yout password",
                textInputType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 24,
              ),

              // enter your Bio
              TextFieldInput(
                textEditingController: _bioController,
                hintText: "Enter Yout Bio",
                textInputType: TextInputType.text,
              ),
              const SizedBox(
                height: 24,
              ),

              // button login
              InkWell(
                onTap: signUpUser,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: _isloading
                      ? const CircularProgressIndicator(
                          color: primaryColor,
                        )
                      : const Text("Sign up"),
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                    color: blueColor,
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Flexible(
                child: Container(
                    // color: mobileBackgroundColor,
                    ),
                flex: 2,
              ),
              // Transining to signing up
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("already have an account?"),
                    GestureDetector(
                      onTap: navigateToLogin,
                      child: const Text(
                        "Login!",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
