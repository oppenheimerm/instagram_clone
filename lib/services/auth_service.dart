import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:instagram_clone/screens/feed_screen.dart';
import 'package:instagram_clone/screens/login_screen.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static final _firestore = Firestore.instance;

  static Future<void> signupUser(BuildContext context, String name, String email,
      String password) async
  {
    try {
      AuthResult authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      FirebaseUser signedInUser = authResult.user;
      if(signedInUser != null){
        _firestore.collection("/users").document(signedInUser.uid).setData({
          'name':name,
          'email':email,
          'profileImageUrl':''
        });
        //  We're using pushReplacmentNamed, instead of just "push",
        //  because when the user signs up, we don't want them to be able
        //  go back to signup screen
        Navigator.pushReplacementNamed(context, FeedScreen.id);
      }
    } catch (e) {
      print(e);
    }
  }

  static void logout(BuildContext context){
    _auth.signOut();
    Navigator.pushReplacementNamed(context, LoginScreen.id);
  }

  static void login(String email, String password) async{
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }
}