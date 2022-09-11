import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:instagram_clone/app/controller/auth_controller.dart';
import 'package:instagram_clone/app/data/bindings/main_bindings.dart';
import 'package:instagram_clone/app/modules/home/controllers/home_controller.dart';
import 'package:instagram_clone/app/modules/login/controllers/login_controller.dart';
import 'package:instagram_clone/app/modules/login/views/login_view.dart';
import 'package:instagram_clone/app/modules/main/views/main_view.dart';
import 'package:instagram_clone/app/utils/colors.dart';
import 'package:instagram_clone/firebase_options.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: MainBindings(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: mobileBackgroundColor,
      ),
      title: "Instagram Clone",
      // initialRoute: AppPages.INITIAL,
      // home:
      // ResponsiveLayout(
      //   webScreenLayout: WebScreenLayout(),
      //   mobileScreenLayout: MobileScreenLayout(),
      // ),
      // home: MerdekaView(),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          // if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            return MainView();
            // return ResponsiveLayout(
            //   webScreenLayout: WebScreenLayout(),
            //   mobileScreenLayout: MobileScreenLayout(),
            // );
          } else if (snapshot.hasError) {
            print('something wrong main.dart ${snapshot.hasError}');
            return Center(
              child: Text('Error\n ${snapshot.error}'),
            );
          }
          // }
          return LoginView();
        },
      ),
      getPages: AppPages.routes,
    );
  }
}
