import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:haiku/locator.dart';
import 'package:haiku/utilities/constants/firebase_keys.dart';

class FirebaseSingletons {
  static final FirebaseSingletons _instance = FirebaseSingletons._internal();
  late final CollectionReference _usersCollection;
  late final CollectionReference _postsCollection;
  late final CollectionReference _clapsCollection;
  late final CollectionReference _talksCollection;
  late final CollectionReference _notificationsCollection;

  FirebaseSingletons._internal() {
    _usersCollection =
        locator<FirebaseFirestore>().collection(FirebaseKeys.users);
    _postsCollection =
        locator<FirebaseFirestore>().collection(FirebaseKeys.posts);
    _clapsCollection =
        locator<FirebaseFirestore>().collection(FirebaseKeys.claps);
    _talksCollection =
        locator<FirebaseFirestore>().collection(FirebaseKeys.talks);    
    _notificationsCollection =
        locator<FirebaseFirestore>().collection(FirebaseKeys.notifications);
  }

  factory FirebaseSingletons() {
    return _instance;
  }

  static CollectionReference get usersCollection => _instance._usersCollection;
  static CollectionReference get postsCollection => _instance._postsCollection;
  static CollectionReference get clapsCollection => _instance._clapsCollection;
  static CollectionReference get talksCollection => _instance._talksCollection;
  static CollectionReference get notificationsCollection => _instance._notificationsCollection;
}
