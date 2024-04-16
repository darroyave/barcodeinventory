import 'package:flutter/material.dart';

import '../service/auth_service.dart';
import '../utils/dimensions.dart';
import '../utils/gradient_color_helper.dart';
import '../utils/styles.dart';
import '../widgets/custom_button_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userNameController =
      TextEditingController(text: "3176994381");
  final TextEditingController _passwordController =
      TextEditingController(text: "12345678");

  final AuthService _authService = AuthService();

  final _formKey = GlobalKey<FormState>();

  Future<void> _login() async {
    String userName = _userNameController.text;
    String password = _passwordController.text;

    try {
      await _authService.login(userName, password);

      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/home');
    } catch (error) {
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Alert'),
            content: const Text('UserName or Password error!!.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
        decoration: BoxDecoration(
          gradient: GradientColorHelper.gradientColor(),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Text(
                    "DailyStop",
                    style: fontSizeBlack.copyWith(
                      fontSize: Dimensions.fontSizeOverOverLarge,
                    ),
                  ),
                  const SizedBox(height: 50),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          onChanged: (value) {},
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter Username";
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.text,
                          controller: _userNameController,
                          decoration: const InputDecoration(
                            hintText: 'Enter UserName',
                            suffixIcon: Icon(
                              Icons.people_outlined,
                              color: Colors.deepPurple,
                            ),
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.deepPurple,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 20),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.deepPurple, width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.deepPurple, width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          onChanged: (value) {},
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter Password";
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            hintText: 'Enter your password',
                            suffixIcon: Icon(
                              Icons.remove_red_eye_sharp,
                              color: Colors.deepPurple,
                            ),
                            prefixIcon: Icon(
                              Icons.lock_open_outlined,
                              color: Colors.deepPurple,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 20),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.deepPurple, width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.deepPurple, width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomButtonWidget(
                          isLoading: false,
                          buttonText: "Sign In",
                          onPressed: () => _login(),
                        ),
                      ],
                    ),
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
