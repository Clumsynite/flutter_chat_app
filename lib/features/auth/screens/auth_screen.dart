import 'package:flutter/material.dart';
import 'package:flutter_chat_app/common/widgets/custom_input.dart';
import 'package:flutter_chat_app/config/global_config.dart';
import 'package:flutter_chat_app/features/auth/services/auth_services.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

enum Auth {
  signin,
  signup,
}

class AuthScreen extends StatefulWidget {
  static const String routeName = "/auth-screen";
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final AuthServices authServices = AuthServices();

  Auth _auth = Auth.signup;

  final _signupFormKey = GlobalKey<FormState>();
  final _signinFormKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final RoundedLoadingButtonController _buttonController =
      RoundedLoadingButtonController();

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(() {
      _buttonController.reset();
    });
    _emailController.addListener(() {
      _buttonController.reset();
    });
    _passwordController.addListener(() {
      _buttonController.reset();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void onSignup() {
    if (_signupFormKey.currentState!.validate()) {
      authServices.signup(
        context: context,
        username: _usernameController.text,
        password: _passwordController.text,
        email: _emailController.text,
        onSuccess: () {
          _buttonController.success();
        },
        onError: () {
          _buttonController.error();
        },
      );
    }
  }

  void onSignin() async {
    if (_signinFormKey.currentState!.validate()) {
      authServices.signin(
        context: context,
        username: _usernameController.text,
        password: _passwordController.text,
        onSuccess: (String id) {
          _buttonController.success();
        },
        onError: () {
          _buttonController.error();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: GlobalConfig.secondaryBackgroundColor,
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalConfig.appBarGradient,
            ),
          ),
          title: const Text(
            "Flutter Chat App",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.grey[100],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListTile(
                title: Text(
                  "Create New Account",
                  style: TextStyle(
                    color:
                        _auth == Auth.signup ? Colors.black : Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                leading: Radio(
                  value: Auth.signup,
                  groupValue: _auth,
                  onChanged: (Auth? value) {
                    setState(() {
                      _auth = value!;
                    });
                  },
                ),
              ),
              if (_auth == Auth.signup)
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(8),
                  child: Form(
                    key: _signupFormKey,
                    child: Column(
                      children: [
                        CustomTextInput(
                          hintText: "Username",
                          controller: _usernameController,
                        ),
                        const SizedBox(height: 10),
                        CustomTextInput(
                          hintText: "Email",
                          controller: _emailController,
                        ),
                        const SizedBox(height: 10),
                        CustomTextInput(
                          hintText: "Password",
                          controller: _passwordController,
                        ),
                        const SizedBox(height: 25),
                        RoundedLoadingButton(
                          onPressed: onSignup,
                          controller: _buttonController,
                          child: const Text(
                            'Sign up',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ListTile(
                title: Text(
                  "Login",
                  style: TextStyle(
                    color:
                        _auth == Auth.signin ? Colors.black : Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                leading: Radio(
                  value: Auth.signin,
                  groupValue: _auth,
                  onChanged: (Auth? value) {
                    setState(() {
                      _auth = value!;
                    });
                  },
                ),
              ),
              if (_auth == Auth.signin)
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(8),
                  child: Form(
                    key: _signinFormKey,
                    child: Column(
                      children: [
                        CustomTextInput(
                          hintText: "Username",
                          controller: _usernameController,
                        ),
                        const SizedBox(height: 10),
                        CustomTextInput(
                          hintText: "Password",
                          controller: _passwordController,
                        ),
                        const SizedBox(height: 25),
                        RoundedLoadingButton(
                          controller: _buttonController,
                          onPressed: onSignin,
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
