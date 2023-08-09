import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pherico_admin_app/config/firebase_constants.dart';
import 'package:pherico_admin_app/config/my_color.dart';
import 'package:pherico_admin_app/config/variables.dart';
import 'package:pherico_admin_app/models/seller/seller.dart';
import 'package:pherico_admin_app/widgets/global/app_bar_withour_back.dart';
import 'package:pherico_admin_app/widgets/global/my_progress_indicator.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class Sellers extends StatefulWidget {
  const Sellers({super.key});

  @override
  State<Sellers> createState() => _SellersState();
}

class _SellersState extends State<Sellers> {
  String searchKeyword = '';
  List<Seller> sellers = [];
  List<Seller> searchList = [];
  bool isSearching = false;
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
                  onChange: (val) {
                    setState(() {
                      isSearching = true;
                    });
                    searchList.clear();
                    for (var item in sellers) {
                      if (item.shopName.toLowerCase().contains(val) ||
                          item.address.toLowerCase().contains(val) ||
                          item.address.toLowerCase().contains(phone)) {
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
                stream:
                    firebaseFirestore.collection(storeCollection).snapshots(),
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
                    sellers =
                        data.map((e) => Seller.fromMap(e.data())).toList();
                    return ListView.builder(
                      itemCount: isSearching
                          ? searchList.length
                          : snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return sellerCard(
                            isSearching ? searchList[index] : sellers[index]);
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
          ],
        ),
      ),
    );
  }
}

Widget sellerCard(Seller seller) {
  return Card(
    elevation: 0,
    color: Colors.transparent,
    margin: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 6),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26.0,
                backgroundImage: CachedNetworkImageProvider(seller.profile),
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
        const Divider(
          thickness: 1.1,
        )
      ],
    ),
  );
}
