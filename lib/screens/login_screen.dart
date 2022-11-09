import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instragran_clone/resources/auth_methods.dart';
import 'package:instragran_clone/screens/login_screen_const.dart';
import 'package:instragran_clone/screens/signup_screen.dart';
import 'package:instragran_clone/utils/colors.dart';
import 'package:instragran_clone/utils/utils.dart';
import 'package:instragran_clone/widgets/text_field_input.dart';
import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isloading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginuser() async {
    setState(() {
      _isloading = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);

    setState(() {
      _isloading = false;
    });
    if (res == "success") {
      // navigate to home screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          ),
        ),
      );
      showSnackBar(res, context);
    } else {
      //
      showSnackBar(res, context);
      print(res);
    }
  }

  navigateToSignUp() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
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

              // svg image
              SvgPicture.asset(
                "assets/ic_instagram.svg",
                color: primaryColor,
                height: svg_height,
              ),
              const SizedBox(
                height: 64,
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

              // button login
              InkWell(
                onTap: () {
                  loginuser();
                },
                child: _isloading
                    ? Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: const CircularProgressIndicator(
                          color: primaryColor,
                        ),
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
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: const Text("Login"),
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
              GestureDetector(
                onTap: navigateToSignUp,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("Dont have an account?"),
                      Text(
                        "SignUp",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
