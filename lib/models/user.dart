import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  User({this.id, this.name, this.profileImageUrl, this.email, this.bio});

  final String id;
  final String name;
  final String profileImageUrl;
  final String email;
  final String bio;

  factory User.fromDoc(DocumentSnapshot documentSnapshot){
    return User(
      id: documentSnapshot.documentID,
      name: documentSnapshot['name'],
      profileImageUrl: documentSnapshot['profileImageUrl'],
      email: documentSnapshot['email'],
      bio: documentSnapshot['bio'] ?? '',
    );
  }
}