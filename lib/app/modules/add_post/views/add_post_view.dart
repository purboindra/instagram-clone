import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:instagram_clone/app/controller/auth_controller.dart';
import 'package:instagram_clone/app/routes/app_pages.dart';

import '../controllers/add_post_controller.dart';

class AddPostView extends GetView<AddPostController> {
  final authC = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          'Postingan Baru',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          GetBuilder<AddPostController>(
              init: AddPostController(),
              builder: (addPC) {
                return TextButton(
                  onPressed: () async {
                    addPC.postImage(
                      authC.userModel.value.uid,
                      authC.userName,
                    );
                  },
                  child: Text(
                    'Bagikan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                  ),
                );
              }),
        ],
      ),
      body: Obx(
        () => Column(
          children: [
            controller.isLoading.isTrue
                ? LinearProgressIndicator()
                : const Padding(
                    padding: EdgeInsetsDirectional.only(),
                  ),
            const Divider(),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 26,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 105,
                    width: 80,
                    child: AspectRatio(
                      aspectRatio: 9 / 14,
                      child: Container(
                        alignment: Alignment.center,
                        height: 105,
                        width: 80,
                        // color: Colors.grey[300],
                        child: GetBuilder<AddPostController>(
                          init: AddPostController(),
                          id: 'pickImage',
                          builder: (addPostC) {
                            return Image.memory(
                              addPostC.file!,
                              height: 105,
                              width: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return SizedBox();
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    width: Get.width * 0.4,
                    child: Obx(() => TextField(
                          controller: controller.descriptionController.value,
                          decoration: InputDecoration(
                            hintText: 'Tulis keterangan...',
                            border: InputBorder.none,
                          ),
                          maxLines: 8,
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
