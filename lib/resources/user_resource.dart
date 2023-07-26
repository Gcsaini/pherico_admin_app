import 'package:pherico_admin_app/config/firebase_constants.dart';
import 'package:pherico_admin_app/models/user.dart';

class UserResource {
  static late User myself;
  static Future<void> getUserInfo() async {
    await firebaseFirestore
        .collection(adminCollection)
        .doc(firebaseAuth.currentUser!.uid)
        .get()
        .then((user) async {
      if (user.exists) {
        myself = User.fromSnap(user);
      }
    });
  }
}
