import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/app/data/model/user_model.dart';
import 'package:instagram_clone/app/data/resources/storage_methods.dart';
import 'package:instagram_clone/app/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone/app/responsive/responsive_layout_screen.dart';
import 'package:instagram_clone/app/responsive/web_screen_layout.dart';
import 'package:instagram_clone/app/routes/app_pages.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var isLoadingLogin = false.obs;
  Rx<UserModel>? _userModel;
  Rx<UserModel> get userModel => _userModel!;
  var userName = '';
  Rx<Uint8List>? img8List;

  var res = ''.obs;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        update(['imageUrl']);

        return pickedFile.readAsBytes();
      }
    } catch (e) {
      print('error ${e.toString()}');
    }
  }

  void selectImage() async {
    Uint8List img = await pickImage();
    if (img8List == null) {
      img8List = img.obs;
      update(['imageUrl']);
    }
  }

  Future<void> clearData() async {
    _auth.signOut();

    UserModel(
        email: '',
        uid: '',
        password: '',
        userName: userName,
        followers: [],
        following: []);
    update();
    Get.offAllNamed(Routes.LOGIN);
  }

  Future<String> signUpUser({
    required String email,
    required String password,
    required String userName,
    // required File file,
    required Uint8List file,
  }) async {
    res = 'something went wrong'.obs;

    try {
      isLoading.value = true;
      if (email.isNotEmpty || password.isNotEmpty || userName.isNotEmpty
          // file.isNotEmpty
          ) {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', false, file);

        UserModel userModel = UserModel(
          email: email,
          uid: userCredential.user!.uid,
          password: password,
          userName: userName,

          // photoUrl: image.path,
          photoUrl: photoUrl,
          followers: [],
          following: [],
        );

        await _firestore.collection('users').doc(userCredential.user!.uid).set(
              userModel.toJson(),
            );

        isLoading.value = false;
        res.value = 'success';
      }
    } on FirebaseException catch (err) {
      if (err.code == 'invalid-email') {
        res.value = 'Email is badly formatted';
      } else if (err.code == 'weak-password') {
        res.value = 'Your password too weak';
      }
      print('error code ${err.code}');
    } catch (e) {
      isLoading.value = false;
      print('error signUpUser $e');
      res.value = e.toString();
    }
    isLoading.value = false;
    return res.value;
  }

  void signUp() async {
    isLoading.value = true;
    String res = await signUpUser(
      email: emailController.text,
      password: passwordController.text,
      userName: usernameController.text,
      file: img8List!.value,
    );
    if (res != 'success') {
      Get.snackbar('Failed', 'Something wrong $res');
      isLoading.value = false;
    } else {
      isLoading.value = false;
      await refreshUser();
      Get.offAllNamed(Routes.MAIN);
    }
    isLoading.value = false;
  }

  Future<UserModel> getUserDetails() async {
    isLoading.value = true;
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();
    update();

    isLoading.value = false;

    return UserModel.fromSnap(snap);
  }

  Future<UserModel> refreshUser() async {
    UserModel userModel = await getUserDetails();
    _userModel = userModel.obs;
    return _userModel!.value;
  }

  Future<String> getUserName() async {
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(_auth.currentUser!.uid).get();
    Map<String, dynamic> data = snap.data() as Map<String, dynamic>;
    userName = data['userName'];
    update(['userName']);

    return userName;
  }

  Future<String> signInUser(
      {required String email, required String password}) async {
    String resLogin = '';

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        resLogin = 'succes';
      } else {
        resLogin = 'All field must be filled';
      }
    } catch (e) {
      resLogin = e.toString();
    }
    return resLogin;
  }

  void signIn() async {
    try {
      isLoadingLogin.value = true;
      String resLogin = await signInUser(
          email: emailController.text, password: passwordController.text);
      if (resLogin == 'success') {
        Get.off(ResponsiveLayout(
          mobileScreenLayout: MobileScreenLayout(),
          webScreenLayout: WebScreenLayout(),
        ));
      }
      isLoadingLogin.value = false;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print(e.message);
        isLoadingLogin.value = false;
      } else if (e.code == 'wrong-password') {
        print(e.message);
        isLoadingLogin.value = false;
      }
    } catch (e) {
      isLoadingLogin.value = false;

      print('error login $e');
    }
    isLoadingLogin.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    // refreshUser();
    getUserName();
  }
}
