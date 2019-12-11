import 'package:flutter/material.dart';
import 'package:instagram_clone/services/auth_service.dart';
import 'package:instagram_clone/widgets/appbar_standard.dart';

class FeedScreen extends StatefulWidget {
  static final String id = 'feed_screen';
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarStandard.stdAppBar(),
      backgroundColor: Colors.blue,
      body: Center(
        child: FlatButton(
          onPressed: () => AuthService.logout(),
          child: Text("LOGOUT"),
        ),
      )
    );
  }
}
