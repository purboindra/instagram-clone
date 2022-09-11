import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:instagram_clone/app/controller/auth_controller.dart';
import 'package:instagram_clone/app/data/resources/firebase_method.dart';
import 'package:instagram_clone/app/modules/comments/widgets/comment_card.dart';
import 'package:intl/intl.dart';

import '../controllers/comments_controller.dart';

class CommentsView extends GetView<CommentsController> {
  final _authC = Get.put(AuthController());
  dynamic snap;

  CommentsView({this.snap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
        centerTitle: false,
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .doc(snap['postId'])
              .collection('comments')
              .orderBy('datePublished', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) {
                    return CommentCard(
                      snap: (snapshot.data as dynamic).docs[index],
                    );
                  });
            }
            return Center(
              child: Text('No connection'),
            );
          }),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          padding: const EdgeInsets.only(
            left: 16,
            right: 8,
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(_authC.userModel.value.photoUrl!),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: TextField(
                  controller: controller.commentsController.value,
                  decoration: InputDecoration(
                    hintText: 'Comment as ${_authC.userName}',
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              InkWell(
                onTap: () async {
                  await FirestoreMethods().postComments(
                    snap['postId'],
                    controller.commentsController.value.text,
                    _authC.userModel.value.uid,
                    _authC.userName,
                    _authC.userModel.value.photoUrl!,
                  );
                  controller.commentsController.value.text = '';
                },
                child: ClipOval(
                  child: Container(
                    width: 32,
                    height: 32,
                    color: Color.fromARGB(255, 11, 45, 147),
                    child: Center(
                      child: Icon(
                        Icons.send,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
