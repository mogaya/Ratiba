import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ratiba_app/configs/constants.dart';
import 'package:ratiba_app/controllers/sign_in_controller.dart';

SignInController signInController = Get.put(SignInController());

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintMessage;
  final bool obscureText;
  final bool isPassword;
  final IconData? icon;
  final Color backgroundColor;

  final IconData? prefIcon;
  final Function()? onTap;
  final InputDecoration? decoration;

  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const CustomTextFormField({
    super.key,
    this.controller,
    this.hintMessage,
    this.obscureText = false,
    this.isPassword = false,
    this.icon,
    this.backgroundColor = Colors.white,
    this.prefIcon,
    this.onTap,
    this.decoration,
    this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        bool isHidden = signInController.isHidden.value;
        return TextFormField(
          keyboardType: keyboardType,
          validator: validator,
          onTap: onTap,
          obscureText: isPassword && isHidden,
          cursorColor: secondaryColor,
          controller: controller,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.normal,
          ),
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: secondaryColor, width: 2),
            ),
            // Error border styles to match regular borders
            errorBorder: const OutlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.black), // Same as enabledBorder
            ),
            errorStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: secondaryColor, width: 2), // Same as focusedBorder
            ),
            contentPadding: const EdgeInsets.fromLTRB(15, 16, 15, 16),
            hintText: hintMessage,
            hintStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w300,
            ),
            prefixIcon: Icon(icon),
            suffixIcon: isPassword
                ? GestureDetector(
                    child: Icon(isHidden
                        ? Icons.visibility_off_sharp
                        : Icons.visibility),
                    onTap: () => signInController.toggleHide(),
                  )
                : null,
          ),
        );
      },
    );
  }
}
