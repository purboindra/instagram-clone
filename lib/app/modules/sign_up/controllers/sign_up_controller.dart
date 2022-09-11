import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/app/data/model/user_model.dart';
import 'package:instagram_clone/app/routes/app_pages.dart';

class SignUpController extends GetxController {
  // final TextEditingController emailController = TextEditingController();
  // final TextEditingController passwordController = TextEditingController();
  // final TextEditingController usernameController = TextEditingController();
  // // Rx<Uint8List>? image;
  // var imagesUrl = File('').obs;

  // var isLoadingSignUp = false.obs;
  // String? res;

  // final Rx<File> _image = File('').obs;
  // File get image => _image.value;
  // var selectedIamgePath = ''.obs;

  // var descriptionController = TextEditingController().obs;

  // Future pickImage() async {
  //   try {
  //     final pickedFile =
  //         await ImagePicker().pickImage(source: ImageSource.gallery);
  //     if (pickedFile != null) {
  //       final imageTemp = File(pickedFile.path);
  //       _image.value = imageTemp;
  //       update();
  //     }
  //   } catch (e) {
  //     print('error ${e.toString()}');
  //   }
  // }

  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Future<String> signUpUser({
  //   required String email,
  //   required String password,
  //   required String userName,
  //   // required Uint8List file,
  //   // required String imageUrl,
  //   String? imageUrl,
  // }) async {
  //   isLoadingSignUp.value = true;
  //   String res = '';

  //   try {
  //     if (email.isNotEmpty || password.isNotEmpty || userName.isNotEmpty) {
  //       UserCredential userCredential =
  //           await _auth.createUserWithEmailAndPassword(
  //         email: email,
  //         password: password,
  //       );

  //       UserModel userModel = UserModel(
  //         email: email,
  //         uid: userCredential.user!.uid,
  //         password: password,
  //         userName: userName,
  //         photoUrl: image.path,
  //         followers: [],
  //         following: [],
  //       );

  //       print('userModel $userModel');

  // await _firestore.collection('users').doc(userCredential.user!.uid).set(
  //       userModel.toJson(),
  //     );
  //       isLoadingSignUp.value = false;
  //       return res = 'success';
  //     }
  //   } catch (e) {
  //     isLoadingSignUp.value = false;
  //     res = e.toString();
  //   }
  //   isLoadingSignUp.value = false;
  //   update();
  //   return res;
  // }

  // void signUp() async {
  //   String res = await signUpUser(
  //     email: emailController.text,
  //     password: passwordController.text,
  //     userName: usernameController.text,
  //     imageUrl: image.path,
  //   );
  //   print('response signUp $res');
  //   if (res != 'success') {
  //     Get.snackbar('Failed', 'Something wrong $res');
  //   } else {
  //     update();
  //     Get.offAllNamed(Routes.HOME);
  //   }
  // }

  // @override
  // void onClose() {
  //   super.onClose();
  //   emailController.clear();
  //   passwordController.clear();
  //   usernameController.clear();
  // }
}
