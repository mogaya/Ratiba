import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ratiba_app/utils/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/',
      theme: ThemeData(
        fontFamily: "Outfit",
      ),
      getPages: Routes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
