import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/services/database_Service.dart';
import 'package:instagram_clone/services/storage_service.dart';

class EditProfile extends StatefulWidget {
  final User user;

  EditProfile({this.user});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _bio = '';
  File _profileImage;
  bool _isLoading = false;

  @override
  initState(){
    super.initState();
    _name = widget.user.name;
    _bio = widget.user.bio;
  }


  _submit()async{
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
      //  Update user in database
      String _profileImageUrl = '';

      setState(() {
        _isLoading = true;
      });

      if(_profileImage == null){
        _profileImageUrl = widget.user.profileImageUrl;
      }else{
        //  update profile image or add new
        _profileImageUrl = await StorageService.uploadUserProfileImage(
            widget.user.profileImageUrl,
            _profileImage
        );
      }

      User user = User(
        id: widget.user.id,
        name: _name,
        profileImageUrl: _profileImageUrl,
        bio: _bio
      );
      DatabaseService.updateUser(user);
      Navigator.pop(context);
    }
  }

  _handleImageFromGallery() async{
    File _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(_imageFile != null){
      setState(() {
        _profileImage = _imageFile;
      });
    }
}

  _displayProfileImage(){
    //  No new profile image
    if(_profileImage == null){
      //  no existing profile image
      if(widget.user.profileImageUrl.isEmpty){
        //  Display place holder
        return AssetImage('assets/images/user_placeholder.jpg');
      }else{
        //  User profile image already exist
        return CachedNetworkImageProvider(widget.user.profileImageUrl);
      }
    }else{
      //  new profile image
      return FileImage(_profileImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'Edit profile',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: GestureDetector(
        //  FocusScope() allows us to click anywhere to rid
        //  screen of keyboard
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          children: <Widget>[
            _isLoading ?
            LinearProgressIndicator(
              backgroundColor: Colors.blue[200],
              valueColor: AlwaysStoppedAnimation(Colors.blue),
            ):
            SizedBox.shrink(),
            Padding(
              padding: EdgeInsets.all(30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                        radius: 60.0,
                        backgroundColor: Colors.grey,
                        backgroundImage:_displayProfileImage()
                    ),
                    FlatButton(
                      onPressed: _handleImageFromGallery,
                      child: Text(
                        'Change profile image',
                        style: TextStyle(
                            color: Theme
                                .of(context)
                                .accentColor, fontSize: 16.0),
                      ),
                    ),
                    TextFormField(
                        initialValue: _name,
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.person,
                              size: 30.0,
                            ),
                            labelText: 'Name'),
                        validator: (input) =>
                        input
                            .trim()
                            .length < 1 ? 'Please enter a valid name' : null,
                        onSaved: (input) => _name = input
                    ),
                    TextFormField(
                      initialValue: _bio,
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.book,
                            size: 30.0,
                          ),
                          labelText: 'Bio'),
                      validator: (input) =>
                      input
                          .trim()
                          .length > 150 ? '150 characters max' : null,
                      onSaved: (input) => _bio = input,
                    ),
                    Container(
                      margin: EdgeInsets.all(40.0),
                      height: 40.0,
                      width: 250.0,
                      child: FlatButton(
                        onPressed: _submit,
                        color: Colors.blue,
                        textColor: Colors.white,
                        child: Text('Save profile',
                          style: TextStyle(
                              fontSize: 18.0
                          ),),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
