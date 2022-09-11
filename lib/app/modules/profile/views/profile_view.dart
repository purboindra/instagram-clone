import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:instagram_clone/app/controller/auth_controller.dart';
import 'package:instagram_clone/app/modules/profile/widgets/follow_button.dart';
import 'package:instagram_clone/app/utils/colors.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  final _authC = Get.put(AuthController());
  final _profileC = Get.put(ProfileController());

  String? uid;

  ProfileView({this.uid});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoading.isTrue
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Scaffold(
              appBar: AppBar(
                title: Text(_authC.userName),
                centerTitle: false,
                backgroundColor: mobileBackgroundColor,
              ),
              body: DefaultTabController(
                length: 3,
                child: SizedBox(
                  height: Get.size.height,
                  width: Get.size.width,
                  child: ListView(
                    physics: ScrollPhysics(),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  backgroundImage: NetworkImage(
                                    controller.userData['photoUrl'],
                                  ),
                                  radius: 40,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Obx(() => BuildStateColumn(
                                                num: _profileC.postLength.value,
                                                label: 'Post',
                                              )),
                                          BuildStateColumn(
                                            num: _profileC.followers.value,
                                            label: 'Followers',
                                          ),
                                          BuildStateColumn(
                                            num: _profileC.following.value,
                                            label: 'Following',
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(
                                top: 12,
                              ),
                              child: Text(
                                controller.userData['userName'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(
                                top: 2,
                              ),
                              child: Text(
                                'A long life learner',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            FirebaseAuth.instance.currentUser!.uid !=
                                    _authC.userModel.value.uid
                                ? FollowButton(
                                    bgColor: Colors.blue,
                                    borderColor: Colors.blue,
                                    textButton: 'Follow',
                                    textColor: Colors.white,
                                    onTap: () {},
                                  )
                                : controller.isFollowing.isTrue
                                    ? FollowButton(
                                        bgColor: Colors.grey.shade200,
                                        borderColor: Colors.grey.shade200,
                                        textButton: 'Unfollow',
                                        textColor: Colors.black,
                                        onTap: () {},
                                      )
                                    : FollowButton(
                                        bgColor:
                                            Color.fromARGB(255, 42, 42, 42),
                                        borderColor:
                                            Color.fromARGB(255, 42, 42, 42),
                                        textButton: 'Edit Profile',
                                        textColor: Colors.white,
                                        onTap: () {},
                                      ),
                            const SizedBox(
                              height: 10,
                            ),
                            Column(
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: mobileBackgroundColor,
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                      color: Color.fromARGB(255, 42, 42, 42),
                                      width: 2,
                                    ),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text('Baru'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection('posts')
                            .where('uid', isEqualTo: _authC.userModel.value.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return GridView.builder(
                            shrinkWrap: true,
                            itemCount: (snapshot.data! as dynamic).docs.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 1.5,
                              childAspectRatio: 1,
                            ),
                            itemBuilder: (context, index) {
                              DocumentSnapshot dataSnap =
                                  (snapshot.data! as dynamic).docs[index];
                              return Container(
                                child: Image(
                                  image: NetworkImage(
                                    dataSnap['photoUrl'],
                                  ),
                                  fit: BoxFit.cover,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      color: Colors.grey.shade400,
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class BuildStateColumn extends StatelessWidget {
  final int num;
  final String label;
  BuildStateColumn({Key? key, required this.num, required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(
            top: 5,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade300,
            ),
          ),
        )
      ],
    );
  }
}
