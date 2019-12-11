import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:instagram_clone/screens/feed_screen.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:instagram_clone/models/user_data.dart';

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

        Provider.of<UserData>(context).currentUserId = signedInUser.uid;

        //  We're using pushReplacmentNamed, instead of just "push",
        //  because when the user signs up, we don't want them to be able
        //  go back to signup screen
        Navigator.pop(context);
      }
    } catch (e) {
      print(e);
    }
  }

  static void logout(){
    _auth.signOut();
    //Navigator.pushReplacementNamed(context, LoginScreen.id);
  }

  static void login(String email, String password) async{

    try{
      print('sigining in with email: ${email} and password: ${password}');
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    }
    catch(e){
      print(e);
    }

  }
}