import 'package:get/get.dart';
import 'package:instagram_clone/app/controller/auth_controller.dart';
import 'package:instagram_clone/app/modules/add_post/controllers/add_post_controller.dart';
import 'package:instagram_clone/app/modules/home/controllers/home_controller.dart';
import 'package:instagram_clone/app/modules/login/controllers/login_controller.dart';
import 'package:instagram_clone/app/modules/main/controllers/main_controller.dart';
import 'package:instagram_clone/app/modules/sign_up/controllers/sign_up_controller.dart';

class MainBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => MainController());
    Get.lazyPut(() => SignUpController());
    Get.lazyPut(() => LoginController());
    Get.lazyPut(() => AuthController());
    Get.lazyPut(() => AddPostController());
  }
}
