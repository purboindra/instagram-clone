import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:instagram_clone/app/controller/auth_controller.dart';
import 'package:instagram_clone/app/modules/sign_up/views/sign_up_view.dart';
import 'package:instagram_clone/app/routes/app_pages.dart';
import 'package:instagram_clone/app/widgets/text_form_field_widgets.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  final _authC = Get.find<AuthController>();
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
              Obx(() => InkWell(
                    onTap: () => _authC.signIn(),
                    child: Container(
                      width: Get.width,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                      ),
                      decoration: ShapeDecoration(
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                        ),
                      ),
                      child: _authC.isLoadingLogin.isTrue
                          ? Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Log in',
                            ),
                    ),
                  )),
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
                    onTap: () => Get.toNamed(Routes.SIGN_UP),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                      child: Text(
                        ' Sign up',
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
