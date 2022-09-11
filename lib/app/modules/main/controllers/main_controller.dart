import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/app/controller/auth_controller.dart';
import 'package:instagram_clone/app/modules/home/views/home_view.dart';
import 'package:instagram_clone/app/modules/profile/views/profile_view.dart';
import 'package:instagram_clone/app/modules/search/views/search_view.dart';

class MainController extends GetxController {
  var selectedIndex = 0.obs;

  List<Widget> body = [
    HomeView(),
    SearchView(),
    Center(
      child: Text("Third Page"),
    ),
    Center(
      child: Text("Foruth Page"),
    ),
    ProfileView(),
  ];

  List<BottomNavigationBarItem> bottomItem = [
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.home),
      label: '',
    ),
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.search),
      label: '',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.video_file_outlined),
      label: '',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.shopping_bag_outlined),
      label: '',
    ),
    BottomNavigationBarItem(
      icon: GetBuilder<AuthController>(
        init: AuthController(),
        builder: (authC) {
          return ClipOval(
            child: Image.network(
              authC.userModel.value.photoUrl!.isEmpty
                  ? 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'
                  : authC.userModel.value.photoUrl!,
              width: 26,
              height: 26,
              fit: BoxFit.cover,
            ),
          );
        },
      ),
      label: '',
    ),
  ];

  void onTap(int index) {
    selectedIndex.value = index;
  }
}
