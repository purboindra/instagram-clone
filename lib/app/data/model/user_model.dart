import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email;
  final String uid;
  final String password;
  final String userName;
  String? photoUrl;
  String? bio;
  final List followers;
  final List following;

  UserModel(
      {required this.email,
      required this.uid,
      this.photoUrl,
      required this.password,
      required this.userName,
      required this.followers,
      required this.following});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'uid': uid,
      'password': password,
      'userName': userName,
      'photoUrl': photoUrl,
      'bio': bio,
      'followers': followers,
      'following': following,
    };
  }

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserModel(
      email: snapshot['email'],
      uid: snapshot['uid'],
      password: snapshot['password'],
      photoUrl: snapshot['photoUrl'],
      userName: snapshot['userName'] != null ? snapshot['userName'] : '',
      followers: snapshot['followers'],
      following: snapshot['following'],
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
