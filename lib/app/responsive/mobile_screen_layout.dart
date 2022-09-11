import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/app/controller/auth_controller.dart';

class MobileScreenLayout extends StatefulWidget {
  MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<AuthController>(
          init: AuthController(),
          id: 'userName',
          builder: (authC) {
            return Center(
              child: Text(authC.userName),
            );
          }),
    );
  }
}
