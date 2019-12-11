import 'package:flutter/material.dart';
import 'package:instagram_clone/widgets/appbar_standard.dart';

class CreatePostScreen extends StatefulWidget {
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarStandard.stdAppBar(),
      body: Center(
        child: Text('Create Post Screen'),
      ),
    );
  }
}