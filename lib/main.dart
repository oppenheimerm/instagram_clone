import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/feed_screen.dart';
import 'package:instagram_clone/screens/home.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/screens/signup_screen.dart';
import 'package:provider/provider.dart';
import 'package:instagram_clone/models/user_data.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  /// Navigate to correct screen on successful
  /// login
  Widget _getScreenId(){
    //  Set up a listener to listen to firebase
    //  authentication.  If user authentication
    // changes, send user to feed screen.  If not
    //  logged in, go to login screen
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot){
        if(snapshot.hasData){
          //  user is now logged in.  Access our [Provider]
          Provider.of<UserData>(context).currentUserId = snapshot.data.uid;
          return HomeScreen();
        }else{
          return LoginScreen();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => UserData(),
      child: MaterialApp(
        title: 'Instagram Clone',
        theme: ThemeData(
            primaryIconTheme: Theme.of(context).primaryIconTheme.copyWith(
                color: Colors.black
            )
        ),
        debugShowCheckedModeBanner: false,
        home: _getScreenId(),
        routes: {
          LoginScreen.id : (context) => LoginScreen(),
          SignupScreen.id: (context) => SignupScreen(),
          FeedScreen.id: (context) => FeedScreen()
        },
      ),
    );
  }
}