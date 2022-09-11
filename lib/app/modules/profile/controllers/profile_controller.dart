import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  var userData = {}.obs;
  var postLength = 0.obs;
  var followers = 0.obs;
  var following = 0.obs;
  var isFollowing = false.obs;
  var isLoading = false.obs;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  getData() async {
    isLoading.value = true;
    var userSnapshot = await _firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    // var postSnap = await _firestore
    //     .collection('posts')
    //     .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
    //     .get();

    var postSnap = await _firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('posts')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    postLength.value = postSnap.docs.length;
    followers.value = userSnapshot.data()!['followers'].length;
    following.value = userSnapshot.data()!['following'].length;
    isFollowing.value = userSnapshot
        .data()!['followers']
        .contains(FirebaseAuth.instance.currentUser!.uid);

    userData.value = userSnapshot.data()!;
    isLoading.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    getData();
  }
}
