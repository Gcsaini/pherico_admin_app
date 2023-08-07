import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pherico_admin_app/config/firebase_constants.dart';
import 'package:pherico_admin_app/config/my_color.dart';
import 'package:pherico_admin_app/screens/about/add-faq.dart';
import 'package:pherico_admin_app/screens/about/edit-faq.dart';
import 'package:pherico_admin_app/utils/toast_extension.dart';
import 'package:pherico_admin_app/widgets/buttons/gradient_elevated_button.dart';
import 'package:pherico_admin_app/widgets/buttons/outlined_button.dart';
import 'package:pherico_admin_app/widgets/buttons/round_button_with_icon.dart';
import 'package:pherico_admin_app/widgets/global/my_progress_indicator.dart';

class Faqs extends StatefulWidget {
  const Faqs({super.key});

  @override
  State<Faqs> createState() => _FaqsState();
}

class _FaqsState extends State<Faqs> {
  showToaster(String msg, {bool isError = false}) {
    context.showToast(msg, isError: isError);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                        ),
                        child: TabBar(
                          indicatorColor: Colors.white,
                          indicatorWeight: 0,
                          indicator: BoxDecoration(
                            gradient: gradient,
                          ),
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.black,
                          tabs: const [
                            Tab(
                              text: 'Buyer',
                            ),
                            Tab(
                              text: 'Seller',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Expanded(
                        child:
                            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream:
                              firebaseFirestore.collection('faq').snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const MyProgressIndicator();
                            } else if (snapshot.hasError) {
                              return const Center(
                                child: Text('Somethig went wrong'),
                              );
                            } else {
                              if (snapshot.hasData && snapshot.data != null) {
                                final data = snapshot.data!.docs;

                                return TabBarView(
                                  children: [
                                    buyerFaq(data),
                                    sellerFaq(data),
                                  ],
                                );
                              } else {
                                return const Center(
                                  child: Text('No data found'),
                                );
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
                  child: RoundButtonWithIcon(
                    height: 46,
                    buttonName: 'Add Faq',
                    onPressed: () {
                      Get.to(() => const AddFaq(),
                          transition: Transition.rightToLeft);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buyerFaq(List<QueryDocumentSnapshot<Map<String, dynamic>>> data) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: data.length,
      itemBuilder: (context, index) {
        return !data[index]['seller']
            ? Dismissible(
                key: Key(data[index]['id']),
                background: Container(
                  color: Colors.green,
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        Text(
                          " Edit",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                ),
                secondaryBackground: Container(
                  color: Colors.red,
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        Text(
                          " Delete",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.endToStart) {
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content:
                              const Text("Are you sure you want to delete ?"),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MyOutlinedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  buttonName: 'Cancel',
                                ),
                                GradientElevatedButton(
                                  buttonName: 'Delete',
                                  onPressed: () async {
                                    await firebaseFirestore
                                        .collection('faq')
                                        .doc(data[index]['id'])
                                        .delete();
                                    Get.back();
                                    showToaster('Deleted');
                                  },
                                )
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    Get.to(
                      () => EditFaq(
                        data: data[index],
                      ),
                      transition: Transition.leftToRight,
                    );
                  }
                },
                child: ExpansionTile(
                  title: Text(data[index]['question']),
                  iconColor: gradient1,
                  textColor: black,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 16),
                      child: Text(
                        data[index]['ans'],
                      ),
                    )
                  ],
                ),
              )
            : Container();
      },
    );
  }

  Widget sellerFaq(List<QueryDocumentSnapshot<Map<String, dynamic>>> data) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: data.length,
      itemBuilder: (context, index) {
        return data[index]['seller']
            ? Dismissible(
                key: Key(data[index]['id']),
                background: Container(
                  color: Colors.green,
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        Text(
                          " Edit",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                ),
                secondaryBackground: Container(
                  color: Colors.red,
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        Text(
                          " Delete",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.endToStart) {
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content:
                              const Text("Are you sure you want to delete ?"),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MyOutlinedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  buttonName: 'Cancel',
                                ),
                                GradientElevatedButton(
                                  buttonName: 'Delete',
                                  onPressed: () async {
                                    await firebaseFirestore
                                        .collection('faq')
                                        .doc(data[index]['id'])
                                        .delete();
                                    Get.back();
                                    showToaster('Deleted');
                                  },
                                )
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    Get.to(
                      () => EditFaq(
                        data: data[index],
                      ),
                      transition: Transition.leftToRight,
                    );
                  }
                },
                child: ExpansionTile(
                  title: Text(data[index]['question']),
                  iconColor: gradient1,
                  textColor: black,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 16),
                      child: Text(
                        data[index]['ans'],
                      ),
                    )
                  ],
                ),
              )
            : Container();
      },
    );
  }
}
