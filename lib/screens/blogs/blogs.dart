import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pherico_admin_app/config/firebase_constants.dart';
import 'package:pherico_admin_app/config/my_color.dart';
import 'package:pherico_admin_app/helpers/time_formatter.dart';
import 'package:pherico_admin_app/models/blogs.dart';
import 'package:pherico_admin_app/screens/blogs/add-blog.dart';
import 'package:pherico_admin_app/utils/border.dart';
import 'package:pherico_admin_app/widgets/buttons/gradient_elevated_button.dart';

import 'package:pherico_admin_app/widgets/global/my_progress_indicator.dart';

class Blogs extends StatelessWidget {
  const Blogs({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 8,
          ),
          child: Column(
            children: [
              Expanded(
                child: FirestoreListView<Map<String, dynamic>>(
                  query: firebaseFirestore.collection(blogCollection),
                  emptyBuilder: (context) {
                    return const Center(
                      child: Text('No blogs found'),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Text('Something went wrong'),
                    );
                  },
                  loadingBuilder: (context) {
                    return const MyProgressIndicator();
                  },
                  itemBuilder: (context, snapshot) {
                    Blog blog = Blog.fromMap(snapshot.data());
                    return blogCard(context, blog);
                  },
                ),
              ),
              addBtn(),
            ],
          ),
        ),
      ),
    );
  }
}

Widget blogCard(BuildContext context, Blog blog) {
  return Card(
    elevation: 0,
    shape: borderShape(radius: 8),
    color: cardBg,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  blog.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  blog.author,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: iconColor,
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                Row(
                  children: [
                    Text(
                      TimeFormatter.getFormattedTime(context, blog.createdAt),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: greyText,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      CupertinoIcons.eye,
                      color: iconColor,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      blog.views.toString(),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: greyText,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        CachedNetworkImage(
          imageUrl: blog.image1,
          height: MediaQuery.of(context).size.height * 0.12,
          width: MediaQuery.of(context).size.width * 0.27,
          fit: BoxFit.cover,
        )
      ],
    ),
  );
}

Widget addBtn() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
    child: GradientElevatedButton(
      buttonName: 'Add',
      height: 46,
      onPressed: () {
        Get.to(() => AddBlog(), transition: Transition.leftToRight);
      },
    ),
  );
}
