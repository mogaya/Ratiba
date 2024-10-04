import 'package:get/get.dart';
import 'package:ratiba_app/views/add_task.dart';
import 'package:ratiba_app/views/home.dart';
import 'package:ratiba_app/views/landing.dart';
import 'package:ratiba_app/views/sign_in.dart';
import 'package:ratiba_app/views/sign_up.dart';

class Routes {
  static var routes = [
    GetPage(name: '/', page: () => const Landing()),
    GetPage(name: '/sign_in', page: () => const SignIn()),
    GetPage(name: '/sign_up', page: () => const SignUp()),
    GetPage(name: '/home', page: () => const Home()),
    GetPage(name: '/add_task', page: () => const AddTask()),
  ];
}
