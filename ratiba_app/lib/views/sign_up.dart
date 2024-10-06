import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ratiba_app/configs/constants.dart';
import 'package:ratiba_app/views/components/customButton.dart';
import 'package:ratiba_app/views/components/customText.dart';
import 'package:ratiba_app/views/components/customTextFormField.dart';

TextEditingController username = TextEditingController();
TextEditingController phone = TextEditingController();
TextEditingController email = TextEditingController();
TextEditingController password = TextEditingController();

class SignUp extends StatefulWidget {
  SignUp({super.key});
  final TextEditingController username = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: baseColor,
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.center,
          child: customText(
            label: "Create your Account",
            fontFamily: 'OpenSans',
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: baseColor,
        elevation: 0,
        foregroundColor: baseColor,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey, // Use the form key here
              child: Column(
                children: [
                  const customText(
                    label:
                        "Karibu TecTally. Please fill in your details to create your account",
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  // username input area
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: customText(
                      label: "Username",
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  CustomTextFormField(
                    hintMessage: "Enter your Username",
                    controller: username,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Username is required';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  // phone input area
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: customText(
                      label: "Phone",
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
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

                  // Email input area
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: customText(
                      label: "Email",
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  CustomTextFormField(
                    hintMessage: "Enter your Email",
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }

                      // Regular expression for validating an email address
                      String pattern =
                          r'^[a-zA-Z0-9]+([._%+-]?[a-zA-Z0-9]+)*@[a-zA-Z0-9]+([.-]?[a-zA-Z0-9]+)*(\.[a-zA-Z]{2,})+$';
                      RegExp regex = RegExp(pattern);

                      if (!regex.hasMatch(value)) {
                        return 'Enter a valid email address';
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
                    child: customText(
                      label: "Password",
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
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
                    height: 30,
                  ),

                  // signIn button
                  SizedBox(
                    width: 350,
                    child: customButton(
                      text: "SIGN UP",
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          serverSignup();
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

                  GestureDetector(
                    onTap: () => Get.toNamed("/sign_in"),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        customText(
                          label: "Already have an account?",
                          txtDecoration: TextDecoration.underline,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        customText(
                          label: "SignIn",
                          labelColor: Colors.blue,
                          txtDecoration: TextDecoration.underline,
                          txtDecColor: Colors.blue,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> serverSignup() async {
    //Loading
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    http.Response response;
    var body = {
      'username': username.text.trim(),
      'phone': phone.text.trim(),
      'email': email.text.trim(),
      'password': password.text.trim()
    };

    response = await http
        .post(Uri.parse("https://mmogaya.com/ratiba/sign_up.php"), body: body);

    if (response.statusCode == 200) {
      var serverResponse = json.decode(response.body);
      int signedUp = serverResponse['success'];

      Navigator.pop(context);

      if (signedUp == 1) {
        // Show a success alert
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Align(
                alignment: Alignment.center,
                child: customText(
                  label: "Success",
                  labelColor: Colors.green,
                  fontSize: 24,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w600,
                ),
              ),
              content: const customText(
                label: "SignUp was successfull, SignIn",
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              actions: <Widget>[
                TextButton(
                  child: const customText(
                    label: "OK",
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                  onPressed: () {
                    username.clear();
                    phone.clear();
                    email.clear();
                    password.clear();

                    // Close the dialog and navigate to sign-in page
                    Get.offAndToNamed("/sign_in");
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }
}
