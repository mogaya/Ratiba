import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:ratiba_app/configs/constants.dart';
import 'package:ratiba_app/views/components/customButton.dart';

class Landing extends StatefulWidget {
  const Landing({super.key});

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: baseColor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Center(
                  child: Lottie.network(
                    'https://lottie.host/4810f37f-e3c5-4139-80c7-3e29612bcce0/PyqgYL7rZO.json',
                    onLoaded: (composition) {
                      setState(() {
                        _isLoading = false;
                      });
                    },
                  ),
                ),
                Text(
                  "Welcome to Ratiba",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
                if (_isLoading)
                  (Center(
                    child: CircularProgressIndicator(
                      color: ascentColor,
                      strokeWidth: 5,
                    ),
                  ))
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              width: 350,
              child: customButton(
                text: "SIGN IN",
                onPressed: () {
                  Get.toNamed('/sign_in');
                },
                txtFontWeight: FontWeight.w600,
                txtFontSize: 18,
                color: secondaryColor,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 350,
              child: customButton(
                text: "CREATE ACCOUNT",
                onPressed: () {
                  Get.toNamed('/sign_up');
                },
                txtFontWeight: FontWeight.w600,
                txtFontSize: 18,
                color: secondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
