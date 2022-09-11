import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:get/get.dart';
import 'package:instagram_clone/app/controller/auth_controller.dart';
import 'package:instagram_clone/app/modules/profile/views/profile_view.dart';

import '../controllers/search_controller.dart';

class SearchView extends GetView<SearchController> {
  final _searchC = Get.put(SearchController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => TextFormField(
            controller: _searchC.searchController.value,
            enableSuggestions: false,
            autocorrect: false,
            decoration: InputDecoration(
              hintText: 'Search',
            ),
            onFieldSubmitted: (value) {
              _searchC.isShowUsers.value = true;
            },
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Obx(
        () => _searchC.isShowUsers.isFalse
            ? FutureBuilder(
                future: FirebaseFirestore.instance.collection('posts').get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return GridView.custom(
                    gridDelegate: SliverQuiltedGridDelegate(
                      crossAxisCount: 3,
                      mainAxisSpacing: 7,
                      crossAxisSpacing: 7,
                      pattern: [
                        QuiltedGridTile(2, 1),
                        QuiltedGridTile(1, 1),
                        QuiltedGridTile(1, 1),
                        QuiltedGridTile(1, 2),
                      ],
                    ),
                    childrenDelegate: SliverChildBuilderDelegate(
                      childCount: controller.images.length,
                      (context, index) => Image.network(
                        controller.images[index],
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey.shade400,
                          );
                        },
                      ),
                    ),
                  );
                },
              )
            : Obx(() => FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .where(
                        'userName',
                        isGreaterThanOrEqualTo:
                            _searchC.searchController.value.text,
                        isNull: _searchC.isUsersNull.value,
                      )
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: (snapshot.data as dynamic).docs.length,
                        itemBuilder: (context, index) {
                          var data = (snapshot.data as dynamic).docs[index];
                          return InkWell(
                            onTap: () {
                              Get.to(
                                () => ProfileView(
                                  uid: Get.put(AuthController())
                                      .userModel
                                      .value
                                      .uid,
                                ),
                              );
                            },
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  data['photoUrl'],
                                ),
                              ),
                              title: Text(
                                data['userName'],
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return SizedBox();
                  },
                )),
      ),
    );
  }
}
