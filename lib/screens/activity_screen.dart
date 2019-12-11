import 'package:flutter/material.dart';
import 'package:instagram_clone/widgets/appbar_standard.dart';

class ActivityScreen extends StatefulWidget {
  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarStandard.stdAppBar(),
      body: Center(
        child: Text('Activity Screen'),
      ),
    );
  }
}
