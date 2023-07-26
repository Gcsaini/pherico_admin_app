import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pherico_admin_app/config/firebase_constants.dart';
import 'package:pherico_admin_app/config/my_color.dart';
import 'package:pherico_admin_app/screens/about/about.dart';
import 'package:pherico_admin_app/screens/about/faqs.dart';
import 'package:pherico_admin_app/screens/about/goal.dart';
import 'package:pherico_admin_app/screens/about/mission.dart';
import 'package:pherico_admin_app/screens/about/vision.dart';
import 'package:pherico_admin_app/widgets/global/my_progress_indicator.dart';

class WebSetting extends StatefulWidget {
  const WebSetting({super.key});

  @override
  State<WebSetting> createState() => _WebSettingState();
}

class _WebSettingState extends State<WebSetting> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
          future: firebaseFirestore.collection('about').get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const MyProgressIndicator();
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Somethig went wrong'),
              );
            } else {
              if (snapshot.hasData && snapshot.data != null) {
                return SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Expanded(
                          child: GridView.builder(
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              List titles = [
                                'About',
                                'Mission',
                                'Vision',
                                'Goal',
                                'Faq'
                              ];
                              List colors = [
                                gradient,
                                linearGradient3,
                                linearGradient1,
                                linearGradient2,
                                gradient
                              ];
                              final data = snapshot.data!.docs[0];
                              return box(size, titles[index], colors[index],
                                  data, index);
                            },
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 1,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return const Center(
                  child: Text('No data found'),
                );
              }
            }
          }),
    );
  }

  Widget box(size, title, gradient, data, index) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      height: size.height * 0.07,
      width: size.width * 0.28,
      decoration: BoxDecoration(
          color: gradient1,
          borderRadius: BorderRadius.circular(12),
          gradient: gradient),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, color: white),
          ),
          InkWell(
            onTap: () {
              if (index == 0) {
                Get.to(
                    () => About(data['about'], data['about_header'],
                        data['about_header_desc'], data['id']),
                    transition: Transition.leftToRight);
              }
              if (index == 1) {
                Get.to(() => Mission(data['mission'], data['id']),
                    transition: Transition.leftToRight);
              }
              if (index == 2) {
                Get.to(() => Vision(data['vision'], data['id']),
                    transition: Transition.leftToRight);
              }
              if (index == 3) {
                Get.to(() => Goal(data['goal'], data['id']),
                    transition: Transition.leftToRight);
              }
              if (index == 4) {
                Get.to(() => const Faqs(), transition: Transition.leftToRight);
              }
            },
            child: Align(
              alignment: Alignment.bottomRight,
              child: Icon(
                CupertinoIcons.arrow_right_circle_fill,
                color: white,
                size: 36,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
