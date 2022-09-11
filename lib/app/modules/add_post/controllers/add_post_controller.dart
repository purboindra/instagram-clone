import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/app/data/resources/firebase_method.dart';
import 'package:instagram_clone/app/routes/app_pages.dart';

class AddPostController extends GetxController {
  // File _image = File('');
  // File get image => _image;
  Uint8List? file;

  var isLoading = false.obs;

  var selectedIamgePath = ''.obs;

  var descriptionController = TextEditingController().obs;

  Future<void> clearImage() async {
    file = null;
    update(['clearImage']);
  }

  Future pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final imageTemp = File(pickedFile.path);
        file = imageTemp.readAsBytesSync();
        if (descriptionController.value.text != '') {
          descriptionController.value.clear();
        }
        update(['pickImage']);
        Get.toNamed(Routes.ADD_POST);
      } else {
        print('error');
      }
    } catch (e) {
      print('error ${e.toString()}');
    }
  }

  void postImage(
    String uid,
    String userName,
  ) async {
    try {
      isLoading.value = true;
      String res = await FirestoreMethods().uploadPost(
        descriptionController.value.text,
        file!,
        uid,
        userName,
      );
      if (res == 'success') {
        isLoading.value = false;
        Get.offAllNamed(Routes.MAIN);
        await clearImage();
      }
    } catch (e) {
      print('error from post image ${e.toString()}');
      isLoading.value = false;
    }
  }
}
