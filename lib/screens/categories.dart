import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pherico_admin_app/config/firebase_constants.dart';
import 'package:pherico_admin_app/config/my_color.dart';
import 'package:pherico_admin_app/models/category_model.dart';
import 'package:pherico_admin_app/screens/add_category.dart';
import 'package:pherico_admin_app/screens/category_edit.dart';
import 'package:pherico_admin_app/utils/border.dart';
import 'package:pherico_admin_app/widgets/buttons/round_button_with_icon.dart';
import 'package:pherico_admin_app/widgets/global/app_bar_withour_back.dart';
import 'package:pherico_admin_app/widgets/global/image_popup.dart';
import 'package:pherico_admin_app/widgets/global/my_progress_indicator.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  String searchKeyword = '';
  List<CategoryModel> categories = [];
  List<CategoryModel> searchList = [];
  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(55),
        child: CustomAppbarWithourBack(
          title: 'Categories',
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 56,
                child: FormHelper.inputFieldWidget(
                  context,
                  'search',
                  'Search categories...',
                  hintColor: HexColor('#4F5663'),
                  hintFontSize: 13,
                  showPrefixIcon: true,
                  focusedErrorBorderWidth: 0,
                  focusedBorderWidth: 0,
                  enabledBorderWidth: 0,
                  borderFocusColor: Colors.transparent,
                  prefixIcon: Icon(
                    CupertinoIcons.search,
                    color: lightBlack,
                  ),
                  prefixIconPaddingLeft: 4,
                  prefixIconPaddingRight: 6,
                  borderRadius: 26,
                  paddingLeft: 0,
                  paddingRight: 0,
                  borderColor: Colors.transparent,
                  backgroundColor: Colors.green.shade50,
                  () {},
                  () {},
                  onChange: (val) {
                    setState(() {
                      isSearching = true;
                    });
                    searchList.clear();
                    for (var item in categories) {
                      if (item.name.toLowerCase().contains(val)) {
                        searchList.add(item);
                      }
                      setState(() {
                        searchList;
                      });
                    }
                  },
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: firebaseFirestore
                    .collection(categoryCollection)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const MyProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text('Something went wrong'),
                    );
                  } else if (snapshot.hasData &&
                      snapshot.data!.docs.isNotEmpty) {
                    final data = snapshot.data!.docs;
                    categories = data
                        .map((e) => CategoryModel.fromMap(e.data()))
                        .toList();
                    return ListView.builder(
                      itemCount: isSearching
                          ? searchList.length
                          : snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return categoryCard(
                            isSearching ? searchList[index] : categories[index],
                            context);
                      },
                    );
                  } else {
                    return const Center(
                      child: Text('Something went wrong'),
                    );
                  }
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
              child: RoundButtonWithIcon(
                height: 46,
                buttonName: 'Add Category',
                onPressed: () {
                  Get.to(
                    () => const AddCategory(),
                    transition: Transition.rightToLeft,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget categoryCard(CategoryModel category, BuildContext context) {
  return Card(
    elevation: 0.5,
    shape: borderShape(radius: 12),
    margin: const EdgeInsets.all(6.0),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          InkWell(
            onTap: () async {
              await showDialog(
                context: context,
                builder: (_) => ImagePopup(image: category.image),
              );
            },
            child: CircleAvatar(
              radius: 30.0,
              backgroundImage: CachedNetworkImageProvider(category.image),
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Text(
              category.name,
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              Get.to(() => EditCategory(category: category),
                  transition: Transition.leftToRight);
            },
            icon: Icon(
              CupertinoIcons.pencil_circle_fill,
              color: black,
              size: 35,
            ),
          )
        ],
      ),
    ),
  );
}
