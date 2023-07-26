import 'package:cloud_firestore/cloud_firestore.dart';

class Blog {
  String id;
  String author;
  String authorProfile;
  String tags;
  String title;
  String desc1;
  String desc2;
  String image1;
  String image2;
  int views;
  List comments;
  String createdAt;
  String updatedAt;

  Blog(
      {required this.author,
      required this.id,
      required this.authorProfile,
      required this.tags,
      required this.title,
      required this.desc1,
      required this.desc2,
      required this.image1,
      required this.image2,
      required this.views,
      required this.comments,
      required this.createdAt,
      required this.updatedAt});

  Map<String, dynamic> toJson() => {
        "id": id,
        "author": author,
        "authorProfile": authorProfile,
        "tags": tags,
        "title": title,
        "desc1": desc1,
        "desc2": desc2,
        "image1": image1,
        "image2": image2,
        "views": views,
        "comments": comments,
        "createdAt": createdAt,
        "updatedAt": updatedAt
      };

  static Blog fromSnap(DocumentSnapshot snap) {
    var snapshop = snap.data() as Map<String, dynamic>;

    return Blog(
      id: snapshop['id'],
      author: snapshop['author'],
      authorProfile: snapshop['authorProfile'],
      tags: snapshop['tags'],
      title: snapshop['title'],
      desc1: snapshop['desc1'],
      desc2: snapshop['desc2'],
      image1: snapshop['image1'],
      image2: snapshop['image2'],
      views: snapshop['views'],
      comments: snapshop['comments'],
      createdAt: snapshop['createdAt'],
      updatedAt: snapshop['updatedAt'],
    );
  }

  static Blog fromMap(Map<String, dynamic> snap) {
    return Blog(
      id: snap['id'],
      author: snap['author'],
      authorProfile: snap['authorProfile'],
      tags: snap['tags'],
      title: snap['title'],
      desc1: snap['desc1'],
      desc2: snap['desc2'],
      image1: snap['image1'],
      image2: snap['image2'],
      views: snap['views'],
      comments: snap['comments'],
      createdAt: snap['createdAt'],
      updatedAt: snap['updatedAt'],
    );
  }
}
