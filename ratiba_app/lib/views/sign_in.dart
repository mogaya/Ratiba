import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ratiba_app/configs/constants.dart';
import 'package:ratiba_app/controllers/sign_in_controller.dart';
import 'package:ratiba_app/views/components/customButton.dart';
import 'package:ratiba_app/views/components/customTextFormField.dart';

TextEditingController phone = TextEditingController();
TextEditingController password = TextEditingController();
SignInController signInController = Get.put(SignInController());

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: baseColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: baseColor,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey, // Tracks Form State
              child: Column(
                children: [
                  const Text(
                    "Welcome Back",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  const Text(
                    "Fill in your Phone and Password to login to your account.",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  // Phone input area
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Phone",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),

                  CustomTextFormField(
                    hintMessage: "Enter your Phone",
                    controller: phone,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Phone number is required';
                      } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                        return 'Please enter a valid 10-digit phone number';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  // password input area
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Password",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),

                  CustomTextFormField(
                    hintMessage: "Enter your Password",
                    controller: password,
                    icon: Icons.lock_outline_rounded,
                    obscureText: true,
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  const SizedBox(
                    height: 80,
                  ),

                  // signIn button
                  SizedBox(
                    width: 350,
                    child: customButton(
                      text: "SIGN IN",
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          remoteLogin(
                              context); // Proceed with login only if the form is valid
                        }
                      },
                      txtFontWeight: FontWeight.w600,
                      txtFontSize: 18,
                      color: secondaryColor,
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => Get.toNamed("/signup"),
                        child: const Row(
                          children: [
                            Text(
                              "Don't have an account?",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "SignUp",
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Login Logic
  Future<void> remoteLogin(BuildContext context) async {
    http.Response response;
    response = await http.get(
      Uri.parse(
          "https://mmogaya.com/ratiba/sign_in.php?email=testuser@gmail.com&password=test123"),
    );
    // response = await http.get(
    //   Uri.parse(
    //       "https://mmogaya.com/tectally/login.php?phone=${phone.text.trim()}&password=${password.text.trim()}"),
    // );

    if (response.statusCode == 200) {
      var serverResponse = json.decode(response.body);
      int loginStatus = serverResponse['success'];

      // Snackbar to notify the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "Sign In Successful, Karibu Ratiba",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          duration: const Duration(seconds: 5),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      );

      if (loginStatus == 1) {
        var userData = serverResponse['userdata'];
        profileController.updateUserPhone(userData['user_phone']);
        profileController.updateUserId(userData['user_id']);
        profileController.updateUserName(userData['user_name']);
        profileController.updateUserEmail(userData['user_email']);
        profileController.updateUserOrganization(userData['user_organization']);

        phone.clear();
        password.clear();

        Get.toNamed("/navigator");
      } else {
        // Show alert if login fails
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Align(
                alignment: Alignment.topCenter,
                child: Text(
                  "Login Failed!",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              content: const Text(
                "Incorrect Phone or Password",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "OK",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }
    }
  }
}
