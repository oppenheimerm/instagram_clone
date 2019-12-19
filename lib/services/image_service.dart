import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImageService{

  final BuildContext context;

  //  Provide a means to respond to the [onPressed] in the
  // create_post_screen
  final VoidCallback onImageSelected;

  ///  when we want to return a value back to the parent, we
  ///   can't use the above VoidCallback, instead we must use the
  ///  below Function([File]) syntax
  final Function(File) onImageChange;

  ImageService({
    @required this.context,
    @required this.onImageSelected,
    @required this.onImageChange
  });


  handleImage(ImageSource imageSource) async{

    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(source: imageSource);

    if(imageFile != null ){

      //  Crop image not working. bug in lib
      imageFile = await cropImage(imageFile);

      //  return a value back to the parent
      onImageChange(imageFile);

      //  call above in calling class, via this
      //  callback
      //
      // notify caller
      onImageSelected();
    }
  }

  Future<File>cropImage(File imageFile) async {
    File croppedImage;
    croppedImage = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      //  The below aspect ration will keep the photo as a square
      aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: "Crop image"
      ),
    );
    return croppedImage;
  }

  void showSelectImageDialog() {
    //  platform check
    return Platform.isIOS ? iosBottomSheet() : androidDialog();
  }

  void iosBottomSheet() {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text('Add photo'),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text('Take photo'),
                onPressed: () => handleImage(ImageSource.camera),
              ),
              CupertinoActionSheetAction(
                child: Text('Choose from gallery'),
                onPressed: () => handleImage(ImageSource.gallery),
              )
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
          );
        }
    );
  }

  void androidDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context){
          return SimpleDialog(
            title: Text('Add photo'),
            children: <Widget>[
              SimpleDialogOption(
                child: Text('Take photo'),
                onPressed: () => handleImage(ImageSource.camera),
              ),
              SimpleDialogOption(
                child: Text('Choose from gallery'),
                onPressed: () => handleImage(ImageSource.gallery),
              ),
              SimpleDialogOption(
                child: Text('Cancel', style: TextStyle(
                  color: Colors.redAccent,
                ),),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        }
    );
  }


}