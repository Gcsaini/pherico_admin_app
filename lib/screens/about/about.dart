import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pherico_admin_app/resources/about_resource.dart';
import 'package:pherico_admin_app/screens/web_setting.dart';
import 'package:pherico_admin_app/utils/toast_extension.dart';
import 'package:pherico_admin_app/widgets/buttons/round_button_with_icon.dart';
import 'package:pherico_admin_app/widgets/global/my_progress_indicator.dart';

class About extends StatefulWidget {
  final String about;
  final String aboutHeader;
  final String aboutHeaderDesc;
  final String docId;
  const About(this.about, this.aboutHeader, this.aboutHeaderDesc, this.docId,
      {super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _aboutHeaderController = TextEditingController();
  final TextEditingController _aboutHeaderDescController =
      TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _aboutController.text = widget.about;
    _aboutHeaderController.text = widget.aboutHeader;
    _aboutHeaderDescController.text = widget.aboutHeaderDesc;
  }

  showToaster(String msg, {bool isError = false}) {
    context.showToast(msg, isError: isError);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _aboutController,
                        decoration: const InputDecoration(labelText: 'About'),
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 25,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextField(
                        controller: _aboutHeaderController,
                        decoration:
                            const InputDecoration(labelText: 'About Header'),
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 25,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextField(
                        controller: _aboutHeaderDescController,
                        decoration: const InputDecoration(
                            labelText: 'About Header Desc'),
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 25,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
                child: _isLoading
                    ? const MyProgressIndicator()
                    : RoundButtonWithIcon(
                        height: 46,
                        buttonName: 'Submit',
                        onPressed: () {
                          handleSubmit();
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void handleSubmit() async {
    if (_aboutController.text.isEmpty || _aboutController.text.length < 50) {
      showToaster('Enter atleas 50 character', isError: true);
    } else if (_aboutHeaderController.text.isEmpty ||
        _aboutHeaderController.text.length < 50) {
      showToaster('Enter atleas 50 character', isError: true);
    } else if (_aboutHeaderDescController.text.isEmpty ||
        _aboutHeaderDescController.text.length < 50) {
      showToaster('Enter atleas 50 character', isError: true);
    } else {
      setState(() {
        _isLoading = true;
      });
      bool res = await AboutResource.updateAbout(
          _aboutController.text,
          _aboutHeaderController.text,
          _aboutHeaderDescController.text,
          widget.docId.trim());
      if (!res) {
        setState(() {
          showToaster('Something went wrong', isError: true);
        });
      } else {
        showToaster('Updated');
        Get.off(() => const WebSetting());
      }
      setState(() {
        _isLoading = false;
      });
    }
  }
}
