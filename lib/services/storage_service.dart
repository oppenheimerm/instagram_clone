import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:instagram_clone/utilities/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  static Future<String> uploadUserProfileImage(
      String url, File imageFile) async {
    //  Create photId as a random Id
    String photoId = Uuid().v4();
    //  compressed passed in image
    File image = await compressImage(photoId, imageFile);

    //  Is user updating profile image?
    //  Check if url we passed in is empty or not
    if (url.isNotEmpty) {
      //  Updating the url profile image. get photo id to
      // update the exact file in the storage bucket
      RegExp exp = RegExp(r'userProfile_(.*).jpg');
      photoId = exp.firstMatch(url)[1];
      print(photoId);
    }

    //  Make an upload task, where we put the file in the exact location
    //  in out firebase storage bucket
    StorageUploadTask uploadTask = storageRef
        .child('images/users/userProfile_$photoId.jpg')
        .putFile(image);

    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    //  This is what we store in our database
    return downloadUrl;
  }

  static Future<File> compressImage(String photoId, File image) async {
    final tmpDir = await getTemporaryDirectory();
    final path = tmpDir.path;
    File compressedImageFile = await FlutterImageCompress.compressAndGetFile(
      image.absolute.path,
      '$path/img_$photoId.jpg',
      quality: 70,
    );
    return compressedImageFile;
  }
}
