import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String description;
  final String uid;
  final String postId;
  final String userName;
  final String datePublished;
  final String photoUrl;
  final String? profileImage;
  final likes;
  final comments;

  PostModel({
    required this.description,
    required this.uid,
    required this.postId,
    required this.userName,
    required this.datePublished,
    required this.photoUrl,
    this.profileImage,
    required this.likes,
    required this.comments,
  });

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'uid': uid,
      'postId': postId,
      'userName': userName,
      'datePublished': datePublished,
      'photoUrl': photoUrl,
      'profileImage': profileImage,
      'likes': likes,
      'comments': comments,
    };
  }

  static PostModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return PostModel(
      description: snapshot['description'],
      uid: snapshot['uid'],
      postId: snapshot['postId'],
      userName: snapshot['userName'],
      datePublished: snapshot['datePublished'],
      photoUrl: snapshot['photoUrl'],
      profileImage: snapshot['profileImage'],
      likes: snapshot['likes'],
      comments: snapshot['comments'],
    );
  }

  // factory UserModel.fromMap(Map<String, dynamic> map) {
  //   return UserModel(
  //     map['email'] ?? '',
  //     map['uid'] ?? '',
  //     map['password'] ?? '',
  //     map['userName'] ?? '',
  //     map['bio'],
  //     List.from(map['followers']),
  //     List.from(map['following']),
  //   );
  // }

  // String toJson() => json.encode(toMap());

  // factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));
}
