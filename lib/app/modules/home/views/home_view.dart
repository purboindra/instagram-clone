import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:instagram_clone/app/controller/auth_controller.dart';
import 'package:instagram_clone/app/data/model/user_model.dart';
import 'package:instagram_clone/app/data/resources/firebase_method.dart';
import 'package:instagram_clone/app/modules/add_post/controllers/add_post_controller.dart';
import 'package:instagram_clone/app/modules/comments/controllers/comments_controller.dart';
import 'package:instagram_clone/app/modules/comments/views/comments_view.dart';
import 'package:instagram_clone/app/widgets/likes_animation.dart';
import 'package:intl/intl.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final _authC = Get.put(AuthController());
  final _commentsC = Get.put(CommentsController());

  @override
  Widget build(BuildContext context) {
    // _authC.clearData();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: _headerLogo(),
      ),
      body: StreamBuilder(
          stream: _fireStore
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('posts')
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('Something Wrong'),
              );
            }
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    _instaStory(),
                    snapshot.data!.docs.isEmpty
                        ? Center(
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/welcome1.png',
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Welcome to instagram',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              var data = snapshot.data!.docs[index];
                              var dateTime = DateFormat().add_yMMMd().format(
                                  DateTime.parse(data['datePublished']));
                              return Container(
                                margin: EdgeInsets.only(bottom: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                      ),
                                      child: Row(
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              // Get.put(AuthController()).clearData();
                                            },
                                            child: ClipOval(
                                              child: Image.network(
                                                _authC
                                                    .userModel.value.photoUrl!,
                                                fit: BoxFit.cover,
                                                width: 40,
                                                height: 40,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(
                                            _authC.userName,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Spacer(),
                                          IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) => Center(
                                                  child: ListView(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 16,
                                                        horizontal: 12),
                                                    shrinkWrap: true,
                                                    children: [
                                                      'Delete',
                                                    ]
                                                        .map(
                                                          (e) => Material(
                                                            child: InkWell(
                                                              onTap: () {
                                                                FirestoreMethods()
                                                                    .deletePost(
                                                                        data[
                                                                            'postId']);
                                                              },
                                                              child: Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                  vertical: 16,
                                                                  horizontal:
                                                                      12,
                                                                ),
                                                                child: Text(e),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                        .toList(),
                                                  ),
                                                ),
                                              );
                                            },
                                            icon: Icon(
                                              Icons.more_horiz_outlined,
                                              size: 32,
                                              color: Colors.grey.shade300,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    //IMAGE POST SECTION
                                    Obx(() => GestureDetector(
                                          onDoubleTap: () async {
                                            controller.isLikeAnimation.value =
                                                true;
                                            await FirestoreMethods().likePost(
                                                data['postId'],
                                                _authC.userModel.value.uid,
                                                data['likes']);
                                          },
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              SizedBox(
                                                height: Get.size.height * 0.35,
                                                width: Get.width,
                                                child: Image.network(
                                                  // controller.instaStory[index]['posting']!,
                                                  data['photoUrl'],
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              AnimatedOpacity(
                                                duration:
                                                    Duration(milliseconds: 200),
                                                opacity: controller
                                                        .isLikeAnimation.value
                                                    ? 1
                                                    : 0,
                                                child: LikesAnimation(
                                                  child: const Icon(
                                                      Icons.favorite,
                                                      color: Colors.white,
                                                      size: 130),
                                                  isAnimation: controller
                                                      .isLikeAnimation.value,
                                                  duration: const Duration(
                                                    milliseconds: 900,
                                                  ),
                                                  onEnd: () => controller
                                                      .changeAnimation(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                      ),
                                      child: GetBuilder<AuthController>(
                                        init: AuthController(),
                                        builder: (authC) {
                                          return Row(
                                            children: [
                                              Row(
                                                children: [
                                                  LikesAnimation(
                                                    isAnimation: data['likes']
                                                        .contains(authC
                                                                .userModel
                                                                .value
                                                                .uid
                                                                .isEmpty
                                                            ? ''
                                                            : authC.userModel
                                                                .value.uid),
                                                    smallLike: true,
                                                    child: InkWell(
                                                      onTap: () async {
                                                        FirestoreMethods()
                                                            .likePost(
                                                                data['postId'],
                                                                _authC.userModel
                                                                    .value.uid,
                                                                data['likes']);
                                                      },
                                                      child: Icon(
                                                        data['likes'].contains(
                                                                _authC.userModel
                                                                    .value.uid)
                                                            ? Icons.favorite
                                                            : Icons
                                                                .favorite_outline,
                                                        color: data['likes']
                                                                .contains(_authC
                                                                    .userModel
                                                                    .value
                                                                    .uid)
                                                            ? Colors.red
                                                            : Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      Get.to(() => CommentsView(
                                                            snap: data,
                                                          ));
                                                      print(data['postId']);
                                                    },
                                                    child: Icon(
                                                      Icons.comment_outlined,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Icon(
                                                    Icons.share_outlined,
                                                    color: Colors.white,
                                                  ),
                                                ],
                                              ),
                                              Spacer(),
                                              Icon(
                                                Icons.bookmark_outline,
                                                color: Colors.white,
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                      ),
                                      child: Row(
                                        children: [
                                          data['likes'].length == 0
                                              ? const SizedBox()
                                              : data['likes'].contains(_authC
                                                      .userModel.value.uid)
                                                  ? Text('Anda menyukai ini')
                                                  : Container(
                                                      width: 80,
                                                      height: 35,
                                                      child: Stack(
                                                        children: [
                                                          Positioned(
                                                            bottom: 0,
                                                            // right: 0,
                                                            left: 0,
                                                            top: 0,
                                                            child: ClipOval(
                                                              child: Container(
                                                                width: 35,
                                                                height: 35,
                                                                child: Image
                                                                    .network(
                                                                  controller
                                                                          .instaStory[4]
                                                                      [
                                                                      'imageUrl']!,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Positioned(
                                                            bottom: 0,
                                                            // right: 0,
                                                            left: 20,
                                                            top: 0,
                                                            child: ClipOval(
                                                              child: Container(
                                                                width: 35,
                                                                height: 35,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ),
                                                          Positioned(
                                                            bottom: 0,
                                                            // right: 0,
                                                            left: 25,
                                                            top: 0,
                                                            child: ClipOval(
                                                              child: Container(
                                                                width: 35,
                                                                height: 35,
                                                                child: Image
                                                                    .network(
                                                                  controller
                                                                          .instaStory[2]
                                                                      [
                                                                      'imageUrl']!,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Positioned(
                                                            bottom: 0,
                                                            // right: 0,
                                                            left: 40,
                                                            top: 0,
                                                            child: ClipOval(
                                                              child: Container(
                                                                width: 35,
                                                                height: 35,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ),
                                                          Align(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child: ClipOval(
                                                              child: Container(
                                                                width: 35,
                                                                height: 35,
                                                                child: Image
                                                                    .network(
                                                                  controller.instaStory[
                                                                          index]
                                                                      [
                                                                      'imageUrl']!,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                                // ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                          data['likes'].length == 0
                                              ? const SizedBox()
                                              : SizedBox(
                                                  width: 15,
                                                ),
                                          data['likes'].length == 0
                                              ? const SizedBox()
                                              : data['likes'].contains(_authC
                                                      .userModel.value.uid)
                                                  ? const SizedBox()
                                                  : RichText(
                                                      text: TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            // text: 'Disukai oleh ',
                                                            text: data['likes']
                                                                .length
                                                                .toString(),
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: ' like'
                                                                .toString(),
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: RichText(
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: data['userName'],
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        '  ${data['description']}',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    GetBuilder<HomeController>(
                                      init: HomeController(),
                                      tag: 'comments',
                                      builder: (homeC) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 15,
                                          ),
                                          child: homeC.commentLength.value == 0
                                              ? const SizedBox()
                                              : Text(
                                                  'View all ${homeC.commentLength.value} comments',
                                                  style: TextStyle(
                                                      color:
                                                          Colors.grey.shade500),
                                                ),
                                        );
                                      },
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                      ),
                                      child: Text(
                                        dateTime,
                                        style: TextStyle(
                                            color: Colors.grey.shade500),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ],
                ),
                // ),
              );
            }
            return Center(
              child: Text('No Connection'),
            );
          }),
    );
  }

  Row _headerLogo() {
    return Row(
      children: [
        Container(
          width: 130,
          height: 40,
          child: Image.asset(
            'assets/instagram_logo.png',
            fit: BoxFit.fitWidth,
            color: Colors.white,
          ),
        ),
        Spacer(),
        Row(
          children: [
            GetBuilder<AddPostController>(
              init: AddPostController(),
              initState: (_) {},
              builder: (addPC) {
                return InkWell(
                  onTap: () async {
                    addPC.pickImage();
                  },
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: () {},
              child: Icon(
                Icons.favorite_outline,
                color: Colors.white,
                size: 26,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Container(
              width: 36,
              height: 36,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    top: 0,
                    child: Icon(
                      Icons.message_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: ClipOval(
                      child: Container(
                        color: Colors.red,
                        width: 18,
                        height: 18,
                        child: Center(
                          child: Text(
                            "9",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Container _instaStory() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        boxShadow: [
          BoxShadow(
            offset: Offset(1, 0),
            color: Colors.black38,
            spreadRadius: 2,
          ),
        ],
      ),
      child: FutureBuilder<UserModel>(
          future: Get.find<AuthController>().refreshUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }

            if (snapshot.hasData) {
              return Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      bottom: 10,
                    ),
                    height: 110,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.instaStory.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(
                            right: 8,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 85,
                                height: 85,
                                child: Stack(
                                  children: [
                                    ClipOval(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: controller.instaStory[index]
                                                      ['name'] ==
                                                  'Your Story'
                                              ? Colors.grey.shade400
                                              : null,
                                          gradient: controller.instaStory[index]
                                                      ['name'] ==
                                                  'Your Story'
                                              ? null
                                              : LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [
                                                    Colors.red,
                                                    Colors.orange,
                                                    Colors.purple,
                                                  ],
                                                ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 3,
                                      right: 3,
                                      top: 3,
                                      bottom: 3,
                                      child: ClipOval(
                                        child: Container(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 6,
                                      right: 6,
                                      top: 6,
                                      bottom: 6,
                                      child: ClipOval(
                                        child: Container(
                                          child: index == 0
                                              ? Image.network(
                                                  snapshot.data!.photoUrl ==
                                                          null
                                                      ? 'https://pkmmontong.tubankab.go.id/files/2021-03/blank-profile-picture-973460-1280.jpg?d20db3663a'
                                                      : snapshot
                                                          .data!.photoUrl!,
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.network(
                                                  controller.instaStory[index]
                                                      ['imageUrl']!,
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                      ),
                                    ),
                                    controller.instaStory[index]['name'] ==
                                            'Your Story'
                                        ? Align(
                                            alignment: Alignment.bottomRight,
                                            child: Container(
                                              width: 22,
                                              height: 22,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                color: Colors.white,
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons.add,
                                                  color: Colors.purple,
                                                  size: 22,
                                                ),
                                              ),
                                            ),
                                          )
                                        : SizedBox(),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Expanded(
                                child: GetBuilder<AuthController>(
                                  init: AuthController(),
                                  builder: (authC) {
                                    return Text(
                                      index == 0
                                          ? authC.userName
                                          : controller.instaStory[index]
                                              ['name']!,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      maxLines: 1,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
            return SizedBox();
          }),
    );
  }
}
