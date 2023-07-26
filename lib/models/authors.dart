import 'package:cloud_firestore/cloud_firestore.dart';

class Author {
  String author;
  String profile;

  Author({
    required this.author,
    required this.profile,
  });

  Map<String, dynamic> toJson() => {
        "author": author,
        "profile": profile,
      };

  static Author fromSnap(DocumentSnapshot snap) {
    var snapshop = snap.data() as Map<String, dynamic>;

    return Author(
      author: snapshop['author'],
      profile: snapshop['profile'],
    );
  }

  static Author fromMap(Map<String, dynamic> snap) {
    return Author(
      author: snap['author'],
      profile: snap['profile'],
    );
  }
}

// List<Author> authors = [
//   Author(
//       author: 'Gopi chand',
//       profile:
//           'https://firebasestorage.googleapis.com/v0/b/pherico-4a1e4.appspot.com/o/profiles%2Fc8ed2310-10c5-11ee-8e56-ed16787f87af?alt=media&token=8eb06ea1-58b3-4219-b44f-97e835b498d8'),
//   Author(author: 'Ujjal Sarkar', profile: defaultProfile)
// ];
