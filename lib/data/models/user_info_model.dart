import 'package:cloud_firestore/cloud_firestore.dart';

class UserInfoModel {
  String? userName;
  String? userId;
  int? score;
  String? email;
  String? deviceToken;
  String? bio;
  String? profilePicPath;
  bool? hasNotifications;

  UserInfoModel({
    this.userName,
    this.userId,
    this.score,
    this.email,
    this.deviceToken,
    this.bio,
    this.profilePicPath,
    this.hasNotifications,
  });

  factory UserInfoModel.fromDocumentSnapshot(
    DocumentSnapshot snapshot,
  ) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    return UserInfoModel(
      userName: data['username'],
      userId: data['uid'],
      score: data['score'],
      email: data['email'],
      deviceToken: data['deviceToken'],
      bio: data['bio'],
      profilePicPath: data['profile_pic_path'],
      hasNotifications: data['has_notifications']
    );
  }
}
