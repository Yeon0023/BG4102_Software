import 'package:bg4102_software/Utilities/glassmorphism.dart';
import 'package:bg4102_software/Utilities/sizeConfiguration.dart';
import 'package:bg4102_software/constats/routes.dart';
import 'package:bg4102_software/service/auth/auth_exception.dart';
import 'package:bg4102_software/service/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Utilities/Show_error_dialog.dart';
import '../Utilities/customAppbar.dart'; //This is to replace print()

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  bool _isBlur = false;
  bool _isObscure = true;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _isObscure = true;
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: SizeConfig.blockSizeHorizontal * 90,
                  height: SizeConfig.blockSizeVertical * 15,
                  // color: Colors.red,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("BreathX",
                        style: GoogleFonts.lobsterTwo(
                            color: Colors.white, fontSize: 90)),
                  ),
                ),
                Container(
                  width: SizeConfig.blockSizeHorizontal * 90,
                  height: SizeConfig.blockSizeVertical * 30,
                  // color: Colors.red,
                  child: Image.asset(
                    'assets/images/party.png',
                    fit: BoxFit.contain,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.blockSizeHorizontal * 5,
                  ),
                  //User email key in box
                  child: TextField(
                    controller: _email,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      label: Text('Username '),
                      prefixIcon: Icon(Icons.email),
                      hintText: 'Enter Your Email Here',
                      focusedBorder: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: SizeConfig.blockSizeVertical * 2,
                ),

                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.blockSizeHorizontal * 5,
                  ),
                  //User Key in Password
                  child: TextField(
                    controller: _password,
                    obscureText: _isObscure,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      label: const Text('Password'),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(_isObscure
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                      hintText: "Enter Your Password Here",
                      focusedBorder: const OutlineInputBorder(),
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Colors.white,
                      )),
                    ),
                  ),
                ),

                SizedBox(
                  height: SizeConfig.blockSizeVertical * 2,
                ),

                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.blockSizeHorizontal * 5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            forgetPasswordRoute,
                            (route) => false,
                          );
                        },
                        child: Text(
                          'Forgot Password ?',
                          style: GoogleFonts.lobster(
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: SizeConfig.blockSizeVertical * 2,
                ),

                //Login Button
                TextButton(
                  onPressed: () async {
                    final email = _email.text;
                    final password = _password.text;
                    try {
                      await AuthService.firebase().logIn(
                        email: email,
                        password: password,
                      );
                      final user = AuthService.firebase().currentUser;
                      if (user?.isEmailVerified ?? false) {
                        //If user email is verified
                        //ignore: use_build_context_synchronously
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          homePageRoute,
                          (route) => false,
                        );
                      } else {
                        // If user email is NOT verified
                        ////ignore: use_build_context_synchronously
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          verifyEmailRoute,
                          (route) => false,
                        );
                      }
                    } on UserNotFoundAuthException {
                      await showErrorDialog(
                        context,
                        'User not found',
                      );
                    } on WrongPasswordAuthException {
                      await showErrorDialog(
                        context,
                        'Wrong Password',
                      );
                    } on GenericAuthException {
                      await showErrorDialog(
                        context,
                        'Authentication Error',
                      );
                    }
                    setState(() {
                      _isBlur = !_isBlur;
                    });
                  },
                  child: SafeArea(
                    child: GlassMorphism(
                      borderThickness: 1,
                      cornerRadius: 4,
                      blur: _isBlur ? 20 : 0,
                      height: SizeConfig.blockSizeVertical * 5,
                      width: SizeConfig.blockSizeHorizontal * 90,
                      opacity: 0.25,
                      child: Center(
                        child: Text(
                          "Sign In!",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lobster(
                            color: Colors.white,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Register redirect button
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      signUpRoute,
                      (route) => false,
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    textStyle: GoogleFonts.lobster(fontSize: 16),
                  ),
                  child: const Text('Not registered yet? Register here!'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
