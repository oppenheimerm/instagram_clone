import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/services/database_Service.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  Future<QuerySnapshot> _users;

  _buildUserTile(User user) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20.0,
        backgroundImage: user.profileImageUrl.isEmpty
            ? AssetImage('assets/images/user_placeholder.jpg')
            : CachedNetworkImageProvider(user.profileImageUrl),
      ),
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ProfileScreen(
                    userId: user.id,
                  ))),
      title: Text(user.name),
    );
  }

  _clearSearch() {
    //_searchController.clear();
    //  https://github.com/flutter/flutter/issues/17647
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _searchController.clear());
    setState(() {
      _users = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 15.0),
              border: InputBorder.none,
              hintText: 'Search',
              prefixIcon: Icon(
                Icons.search,
                size: 30.0,
              ),
              suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: _clearSearch,
              ),
              filled: true,
            ),
            onSubmitted: (input) {
              print(input);
              if (input.isNotEmpty) {
                setState(() {
                  _users = DatabaseService.searchUsers(input);
                });
              }
            },
          ),
        ),
        body: _users == null
            ? Center(
                child: Text("Search for a user"),
              )
            : FutureBuilder(
                future: _users,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.data.documents.length == 0) {
                    return Center(
                      child: Text('No users found! Please try again'),
                    );
                  }
                  return ListView.builder(
                      //  amount of user matching this criteria
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (BuildContext context, int index) {
                        //  Convert snapshot.document into a user object
                        User user =
                            User.fromDoc(snapshot.data.documents[index]);
                        return _buildUserTile(user);
                      });
                },
              ));
  }
}
