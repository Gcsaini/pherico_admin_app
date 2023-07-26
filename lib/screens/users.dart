import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pherico_admin_app/config/firebase_constants.dart';
import 'package:pherico_admin_app/models/user.dart';
import 'package:pherico_admin_app/utils/border.dart';
import 'package:pherico_admin_app/widgets/global/app_bar_withour_back.dart';

class Users extends StatelessWidget {
  const Users({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(55),
        child: CustomAppbarWithourBack(
          title: 'Users',
        ),
      ),
      body: SafeArea(
        child: FirestoreListView<Map<String, dynamic>>(
          pageSize: 20,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          query: firebaseFirestore.collection(usersCollection),
          itemBuilder: (context, snapshot) {
            User user = User.fromMap(snapshot.data());
            return userCard(user);
          },
        ),
      ),
    );
  }
}

Widget userCard(User user) {
  return Card(
    elevation: 0.5,
    shape: borderShape(radius: 12),
    margin: const EdgeInsets.all(6.0),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30.0,
            backgroundImage: CachedNetworkImageProvider(user.profile),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${user.firstName} ${user.lastName}',
                  style: const TextStyle(
                      fontSize: 14.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4.0),
                Text(user.email),
                const SizedBox(height: 4.0),
                Text(user.phone),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
