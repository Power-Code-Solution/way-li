import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'bottom_nav_view.dart';

class BottomNavWrapper extends StatefulWidget {
  const BottomNavWrapper({super.key});

  @override
  State<BottomNavWrapper> createState() => _BottomNavWrapperState();
}

class _BottomNavWrapperState extends State<BottomNavWrapper> {


  @override
  Widget build(BuildContext context) {
    return BottomNavView(); // 👈 Your existing view
  }
}
