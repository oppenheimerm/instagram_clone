import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/models/user_data.dart';
import 'package:instagram_clone/screens/edit_profile.dart';
import 'package:instagram_clone/utilities/constants.dart';
import 'package:instagram_clone/widgets/appbar_standard.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {

  final String userId;
  ProfileScreen({this.userId});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  // Can only edit profile for self only
  bool _isSelf(){
    var isSelf = widget.userId == Provider.of<UserData>(context).currentUserId?
    true :
    false;
    return isSelf;
  }

  @override
  Widget build(BuildContext context) {
    _isSelf();
    return Scaffold(
      appBar: AppBarStandard.stdAppBar(),
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: usersRef.document(widget.userId).get(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          //  testing
          //print(snapshot.data['name']);
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          User user = User.fromDoc(snapshot.data);

          return ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0.0),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 50.0,
                      backgroundColor: Colors.grey,
                      backgroundImage: user.profileImageUrl.isEmpty ?
                      AssetImage(
                        'assets/images/user_placeholder.jpg'
                      ) : CachedNetworkImageProvider(
                        user.profileImageUrl
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text(
                                    '12',
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w600
                                    ),
                                  ),
                                  Text(
                                    'post',
                                    style: TextStyle(
                                      color: Colors.black54,

                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    '386',
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w600
                                    ),
                                  ),
                                  Text(
                                    'followers',
                                    style: TextStyle(
                                      color: Colors.black54,

                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    '345',
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w600
                                    ),
                                  ),
                                  Text(
                                    'following',
                                    style: TextStyle(
                                      color: Colors.black54,

                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                         // Conditional rendering starts
                         // Only show edit profile button if self
                         _isSelf()?
                         Container(
                           width: 200.0,
                           child: FlatButton(
                             color: Colors.blue,
                             onPressed: () => Navigator.push(
                                 context,
                                 MaterialPageRoute(
                                     builder: (_) => EditProfile(
                                         user: user
                                     )
                                 )
                             ),
                             textColor: Colors.white,
                             child: Text(
                               'Edit Profile',
                               style: TextStyle(
                                   fontSize: 18.0
                               ),
                             ),
                           ),
                         ):
                         new Container(width: 0, height: 0,
                         ),
                          // Conditional rendering ends
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(user.name,
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5.0,),
                    Container(
                      height: 80.0,
                      child: Text(user.bio,
                        style: TextStyle(
                          fontSize: 15.0,

                        ),),
                    ),
                    Divider(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
