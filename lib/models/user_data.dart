import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  String uid;
  String name;
  dynamic chats;
  String username;

  UserData(
      {required this.uid,
      required this.name,
      required this.chats,
      required this.username});

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "chats": chats,
        "username": username,
      };

  static UserData fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserData(
      uid: snapshot['uid'],
      name: snapshot['name'],
      chats: snapshot['chats'],
      username: snapshot['username'],
    );
  }
}
