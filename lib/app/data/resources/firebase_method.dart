import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/app/data/model/post.dart';
import 'package:instagram_clone/app/data/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //DELETING POST
  Future<void> deletePost(String postId) async {
    await _firestore.collection('posts').doc(postId).delete();
    Get.back();
    Future.delayed(
      Duration(milliseconds: 600),
      () => Get.rawSnackbar(
          title: 'Success Delete', messageText: Text('Deleting this post')),
    );
  }

  //COMMENTDS
  Future<void> postComments(
    String postId,
    String text,
    String uid,
    String name,
    String profilePict,
  ) async {
    String commentId = Uuid().v1();
    try {
      if (text.isNotEmpty) {
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePict': profilePict,
          'name': name,
          'uid': uid,
          'text': text,
          commentId: commentId,
          'datePublished': DateTime.now(),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //LIKE POST
  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('posts')
            .doc(postId)
            .update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('posts')
            .doc(postId)
            .update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

//UPLOAD
  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String userName,
    // String photoUrl,
  ) async {
    String res = 'Some error occured';
    try {
      String photoUrl = await StorageMethods().uploadImageToStorage(
        'post',
        true,
        file,
      );

      String postId = Uuid().v1();

      PostModel postModel = PostModel(
        description: description,
        uid: uid,
        postId: postId,
        userName: userName,
        datePublished: DateTime.now().toIso8601String(),
        photoUrl: photoUrl,
        // profileImage: profileImage,
        likes: [],
        comments: [],
      );

      await _firestore
          .collection('users')
          .doc(uid)
          .collection('posts')
          .doc(postId)
          .set(postModel.toJson());

      res = 'success';
    } catch (e) {
      res = e.toString();
      print('res from uploadPost $res');
    }
    return res;
  }
}
