import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pherico_admin_app/config/my_color.dart';
import 'package:pherico_admin_app/resources/about_resource.dart';
import 'package:pherico_admin_app/screens/web_setting.dart';
import 'package:pherico_admin_app/utils/toast_extension.dart';
import 'package:pherico_admin_app/widgets/buttons/round_button_with_icon.dart';
import 'package:pherico_admin_app/widgets/global/my_progress_indicator.dart';

class Vision extends StatefulWidget {
  final String vision;
  final String docId;
  const Vision(this.vision, this.docId, {super.key});

  @override
  State<Vision> createState() => _VisionState();
}

class _VisionState extends State<Vision> {
  final TextEditingController _visionController = TextEditingController();
  String error = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _visionController.text = widget.vision;
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _visionController,
                      decoration: const InputDecoration(labelText: 'Vision'),
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 25,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    error.isNotEmpty
                        ? Text(
                            'Error',
                            style: TextStyle(color: red),
                          )
                        : Container(),
                  ],
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
    if (_visionController.text.isEmpty || _visionController.text.length < 50) {
      setState(() {
        error = 'Enter atleas 50 character';
      });
    } else {
      setState(() {
        _isLoading = true;
      });
      bool res = await AboutResource.updateAboutSection(
          _visionController.text, 'vision', widget.docId.trim());
      if (!res) {
        setState(() {
          error = 'Something went wrong';
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
