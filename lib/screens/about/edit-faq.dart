import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pherico_admin_app/config/firebase_constants.dart';
import 'package:pherico_admin_app/config/my_color.dart';
import 'package:pherico_admin_app/screens/about/faqs.dart';
import 'package:pherico_admin_app/utils/toast_extension.dart';
import 'package:pherico_admin_app/widgets/buttons/round_button_with_icon.dart';
import 'package:pherico_admin_app/widgets/global/my_progress_indicator.dart';

class EditFaq extends StatefulWidget {
  final data;
  const EditFaq({super.key, this.data});

  @override
  State<EditFaq> createState() => _EditFaqState();
}

class _EditFaqState extends State<EditFaq> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _ansController = TextEditingController();
  FaqType? _selectedType;
  bool _isLoading = false;

  showToaster(String msg, {bool isError = false}) {
    context.showToast(msg, isError: isError);
  }

  @override
  void initState() {
    super.initState();
    _questionController.text = widget.data['question'];
    _ansController.text = widget.data['ans'];
    _selectedType = widget.data['seller'] ? types[0] : types[1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    DropdownButton<FaqType>(
                      isExpanded: true,
                      value: _selectedType,
                      hint: const Text('Select Type'),
                      borderRadius: BorderRadius.circular(10),
                      dropdownColor: inputBoxColor,
                      underline: const SizedBox(),
                      onChanged: (FaqType? newValue) {
                        setState(() {
                          _selectedType = newValue!;
                        });
                      },
                      items: types
                          .map<DropdownMenuItem<FaqType>>((FaqType option) {
                        return DropdownMenuItem<FaqType>(
                          value: option,
                          child: Text(option.type),
                        );
                      }).toList(),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextField(
                      controller: _questionController,
                      decoration: const InputDecoration(labelText: 'Question'),
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 25,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextField(
                      controller: _ansController,
                      decoration: const InputDecoration(labelText: 'Ans'),
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 25,
                    ),
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
                        buttonName: 'Edit',
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

  handleSubmit() async {
    if (_questionController.text.isEmpty) {
      showToaster('Enter question', isError: true);
    } else if (_ansController.text.isEmpty) {
      showToaster('Enter answer', isError: true);
    } else {
      setState(() {
        _isLoading = true;
      });
      try {
        await firebaseFirestore
            .collection('faq')
            .doc(widget.data['id'])
            .update({
          'seller': _selectedType!.type == 'seller' ? true : false,
          'question': _questionController.text.trim(),
          'ans': _ansController.text.trim(),
        });
        showToaster('Edit successfully');
        Get.off(() => const Faqs());
      } catch (error) {
        showToaster('Something went wrong', isError: true);
      }
    }
  }
}

class FaqType {
  String type;

  FaqType({
    required this.type,
  });
}

List<FaqType> types = [
  FaqType(type: 'seller'),
  FaqType(type: 'buyer'),
];
