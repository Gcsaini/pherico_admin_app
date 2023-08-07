import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pherico_admin_app/config/firebase_constants.dart';
import 'package:pherico_admin_app/config/my_color.dart';
import 'package:pherico_admin_app/models/seller/seller.dart';
import 'package:pherico_admin_app/models/user.dart';
import 'package:pherico_admin_app/utils/border.dart';
import 'package:pherico_admin_app/widgets/global/app_bar_withour_back.dart';
import 'package:pherico_admin_app/widgets/global/image_popup.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class Sellers extends StatelessWidget {
  const Sellers({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(55),
        child: CustomAppbarWithourBack(
          title: 'Sellers',
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
                  'Search seller...',
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
                ),
              ),
            ),
            Expanded(
              child: FirestoreListView<Map<String, dynamic>>(
                pageSize: 20,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                query: firebaseFirestore.collection(storeCollection),
                itemBuilder: (context, snapshot) {
                  Seller seller = Seller.fromMap(snapshot.data());
                  return userCard(seller, context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget userCard(Seller seller, BuildContext context) {
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
                builder: (_) => ImagePopup(image: seller.profile),
              );
            },
            child: CircleAvatar(
              radius: 30.0,
              backgroundImage: CachedNetworkImageProvider(seller.profile),
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  seller.shopName,
                  style: const TextStyle(
                      fontSize: 14.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4.0),
                Text(seller.address),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
