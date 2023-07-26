import 'package:flutter/services.dart';
import 'package:pherico_admin_app/config/firebase_constants.dart';
import 'package:pherico_admin_app/models/blogs.dart';
import 'package:pherico_admin_app/resources/storage_methods.dart';
import 'package:pherico_admin_app/utils/pick_image.dart';
import 'package:uuid/uuid.dart';

class BlogResource {
  static Future<bool> uploadBlog(String author, String profile, String title,
      String tags, String desc1, String desc2, List images) async {
    try {
      List<String> imageUrls = [];
      for (var image in images) {
        Uint8List imageData = await compressImage(image);
        String child = const Uuid().v1();
        String imageUrl = await uploadImage(child, imageData, 'products');
        imageUrls.add(imageUrl);
      }
      String docId = const Uuid().v1();
      Blog blog = Blog(
        id: docId,
        author: author,
        authorProfile: profile,
        tags: tags,
        title: title,
        desc1: desc1,
        desc2: desc2,
        image1: imageUrls[0],
        image2: imageUrls.length > 1 ? imageUrls[1] : '',
        views: 0,
        comments: [],
        createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
        updatedAt: DateTime.now().millisecondsSinceEpoch.toString(),
      );
      await firebaseFirestore
          .collection(blogCollection)
          .doc(docId)
          .set(blog.toJson());
      return true;
    } catch (error) {
      return false;
    }
  }
}
