import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wayli/app/core/config/constants.dart';
import 'package:wayli/app/modules/login/login_view.dart';

class SplashScreenView extends StatefulWidget {
  static const routeName = '/splash-screen';
  const SplashScreenView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenViewState createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
    Future.delayed(Duration(seconds: 5), () {
      Get.to(() => LoginView());
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage('assets/images/way-li_logo.png'),
        //     fit: BoxFit.cover,
        //   ),
        // ),
            decoration: BoxDecoration(
          color: primaryColor,
        ),
        child: Center(
          child: FadeTransition(
            opacity: _animation,
            child: Container(
              width: 150.0,
              height: 150.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: secondaryColor,
                  width: 5,
                ),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.black.withOpacity(0.1),
                //     spreadRadius: 2,
                //     blurRadius: 2,
                //     offset: Offset(0, 1),
                //   ),
                // ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/way-li_logo.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
