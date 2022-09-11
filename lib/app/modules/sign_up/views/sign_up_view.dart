import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:instagram_clone/app/controller/auth_controller.dart';
import 'package:instagram_clone/app/routes/app_pages.dart';
import 'package:instagram_clone/app/widgets/text_form_field_widgets.dart';

import '../controllers/sign_up_controller.dart';

class SignUpView extends GetView<SignUpController> {
  final _authC = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 26,
          ),
          width: Get.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Container(),
                flex: 2,
              ),
              Image.asset(
                'assets/instagram_logo.png',
                color: Colors.white,
                fit: BoxFit.cover,
                // width: 120,
                height: 64,
              ),
              SizedBox(
                height: 64,
              ),
              GetBuilder<AuthController>(
                init: AuthController(),
                id: 'imageUrl',
                initState: (_) {},
                builder: (authC) {
                  return Stack(
                    children: [
                      authC.img8List != null
                          ? CircleAvatar(
                              radius: 64,
                              backgroundImage: MemoryImage(
                                authC.img8List!.value,
                              ),
                            )
                          : CircleAvatar(
                              radius: 64,
                              backgroundImage: NetworkImage(
                                'https://thumbs.dreamstime.com/b/default-profile-picture-avatar-photo-placeholder-vector-illustration-default-profile-picture-avatar-photo-placeholder-vector-189495158.jpg',
                              ),
                            ),
                      Positioned(
                        left: 80,
                        bottom: -10,
                        child: IconButton(
                          onPressed: () async {
                            // _authC.pickImage();
                            _authC.selectImage();
                          },
                          icon: const Icon(
                            Icons.add_a_photo,
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
              SizedBox(
                height: 24,
              ),
              TextFormFieldWidgets(
                textEditingController: _authC.usernameController,
                hintText: 'Enter your username',
                isPass: false,
                textInputType: TextInputType.text,
              ),
              SizedBox(
                height: 24,
              ),
              TextFormFieldWidgets(
                textEditingController: _authC.emailController,
                hintText: 'Enter your email',
                isPass: false,
                textInputType: TextInputType.emailAddress,
              ),
              SizedBox(
                height: 24,
              ),
              TextFormFieldWidgets(
                textEditingController: _authC.passwordController,
                hintText: 'Enter your password',
                isPass: true,
                textInputType: TextInputType.text,
              ),
              const SizedBox(
                height: 24,
              ),
              Obx(
                () => InkWell(
                    onTap: () {
                      if (_authC.isLoading.isTrue) {
                        null;
                      } else {
                        _authC.signUp();
                      }
                      // controller.signUp();
                      // Get.put(AuthController()).signUpUser(
                      //   email: controller.emailController.text,
                      //   password: controller.passwordController.text,
                      //   username: controller.usernameController.text,
                      //   file: controller.image,
                      // );
                    },
                    child: Container(
                      width: Get.width,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                        // vertical: _authC.isLoading.isTrue ? 20 : 10,
                        vertical: 10,
                      ),
                      decoration: ShapeDecoration(
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                        ),
                      ),
                      child: _authC.isLoading.isTrue
                          ? Center(
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Sign Up',
                            ),
                    )),
              ),
              const SizedBox(
                height: 12,
              ),
              Flexible(
                child: Container(),
                flex: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                    child: Text(
                      'Dont\'t have an account?',
                    ),
                  ),
                  InkWell(
                    onTap: () => Get.toNamed(Routes.LOGIN),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                      child: Text(
                        ' Sign In',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
