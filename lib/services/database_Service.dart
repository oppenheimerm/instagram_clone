import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/utilities/constants.dart';

class DatabaseService {
  static void updateUser(User user) {
    usersRef.document(user.id).updateData({
      'name': user.name,
      'profileImageUrl': user.profileImageUrl,
      'bio': user.bio,
    });
  }

  static Future<QuerySnapshot> searchUsers(String name) {
    Future<QuerySnapshot> users =
        usersRef.where('name', isGreaterThanOrEqualTo: name).getDocuments();
    return users;
  }

  static void createPost(Post post){
    postRef.document(post.authorId).collection('usersPosts').add({
      'imageUrl': post.imageUrl,
      'caption': post.caption,
      /*'likeCount': post.likeCount,*/
      'authorId': post.authorId,
      'timestamp': post.timestamp,
    });
  }
}
