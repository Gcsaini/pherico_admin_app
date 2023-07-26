import 'package:pherico_admin_app/config/firebase_constants.dart';

class AboutResource {
  static Future<bool> updateAboutSection(
      String value, String field, String docId) async {
    try {
      if (field == 'mission') {
        await firebaseFirestore
            .collection('about')
            .doc(docId)
            .update({'mission': value});
      }
      if (field == 'vision') {
        await firebaseFirestore
            .collection('about')
            .doc(docId)
            .update({'vision': value});
      }
      if (field == 'goal') {
        await firebaseFirestore
            .collection('about')
            .doc(docId)
            .update({'goal': value});
      }
      if (field == 'about') {
        await firebaseFirestore
            .collection('about')
            .doc(docId)
            .update({'about': value});
      }
      if (field == 'about_header') {
        await firebaseFirestore
            .collection('about')
            .doc(docId)
            .update({'about_header': value});
      }
      if (field == 'about_header_desc') {
        await firebaseFirestore
            .collection('about')
            .doc(docId)
            .update({'about_header_desc': value});
      }
      return true;
    } catch (error) {
      return false;
    }
  }

  static Future<bool> updateAbout(String about, String aboutHeader,
      String aboutHeaderDesc, String docId) async {
    try {
      await firebaseFirestore.collection('about').doc(docId).update({
        'about': about,
        'about_header': aboutHeader,
        'about_header_desc': aboutHeaderDesc
      });

      return true;
    } catch (error) {
      return false;
    }
  }
}
