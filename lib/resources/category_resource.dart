import 'dart:typed_data';

import 'package:pherico_admin_app/config/firebase_constants.dart';
import 'package:pherico_admin_app/resources/storage_methods.dart';
import 'package:pherico_admin_app/utils/pick_image.dart';
import 'package:uuid/uuid.dart';

class CategoryResource {
  static Future<bool> postCategory(Uint8List image, String title) async {
    try {
      Uint8List imageData = await compressImage(image);
      String child = const Uuid().v1();
      String imageUrl = await uploadImage(child, imageData, 'category');
      String docId = const Uuid().v1();
      await firebaseFirestore.collection(categoryCollection).doc(docId).set(
            ({'id': docId, 'name': title, 'image': imageUrl, 'status': true}),
          );
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateCategory(String title, String docId) async {
    try {
      await firebaseFirestore
          .collection(categoryCollection)
          .doc(docId)
          .update(({'name': title}));
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateCategoryWithImage(
      Uint8List image, String title, String docId) async {
    try {
      Uint8List imageData = await compressImage(image);
      String child = const Uuid().v1();
      String imageUrl = await uploadImage(child, imageData, 'category');
      await firebaseFirestore.collection(categoryCollection).doc(docId).update(
            ({
              'name': title,
              'image': imageUrl,
            }),
          );
      return true;
    } catch (e) {
      return false;
    }
  }
}
