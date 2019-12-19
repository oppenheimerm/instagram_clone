import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/models/user_data.dart';
import 'package:instagram_clone/services/database_Service.dart';
import 'package:instagram_clone/services/image_service.dart';
import 'package:instagram_clone/services/storage_service.dart';
import 'package:provider/provider.dart';

class CreatePostScreen extends StatefulWidget {
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  File _image;
  TextEditingController _captionController = TextEditingController();
  String _caption = '';
  bool _isLoading = false;


  _submit() async {
    if (!_isLoading && _image != null && _caption.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      print('Submit() called');

      //  Create post
      String imageUrl = await StorageService.uploadPost(_image);
      Post post = Post(
        imageUrl: imageUrl,
        caption: _caption,
        likes: {},
        authorId: Provider.of<UserData>(context).currentUserId,
        timestamp: Timestamp.fromDate(DateTime.now()),
      );
      DatabaseService.createPost(post);

      //  reset data
      //  clear caption controller
      _captionController.clear();
      setState(() {
        _resetInputs();
      });
    }
  }

  void _resetInputs() {
    _caption = '';
    _image = null;
    _isLoading = false;
  }

  void onImageSelected() {
    print('handle image clallback');
  }

  onImageChange(File val) {
    setState(() {
      print('image file: $val');
      _image = val;
      print("_image value:$val");
    });
  }



  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    ImageService imageService = ImageService(
        context: context,
        onImageSelected: onImageSelected,
        onImageChange: onImageChange);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Create Post',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: _submit,
            ),
          ],

        ),
          //  wrap in GestureDetector to close / open keyboard
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Container(
              height: _height,
              child: Column(
                children: <Widget >[
                  _isLoading ? Padding(
                  padding: EdgeInsets.only(
                    bottom: 10.0,
                  ),
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.blue[200],
                      valueColor: AlwaysStoppedAnimation(
                        Colors.blue
                      ),
                    ),
                  ):SizedBox.shrink(),
                  GestureDetector(
                    onTap: imageService.showSelectImageDialog,
                    child: Container(
                      height: _width,
                      width: _width,
                      color: Colors.grey[300],
                      child: _image == null
                          ? Icon(
                              Icons.add_a_photo,
                              color: Colors.white70,
                              size: 150.0,
                            )
                          : Image(
                              image: FileImage(_image),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: TextField(
                        controller: _captionController,
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Caption',
                        ),
                      onChanged: (input) => _caption = input,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
