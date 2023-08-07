import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pherico_admin_app/resources/category_resource.dart';
import 'package:pherico_admin_app/screens/categories.dart';
import 'package:pherico_admin_app/utils/crop_image.dart';
import 'package:pherico_admin_app/utils/pick_image.dart';
import 'package:pherico_admin_app/utils/toast_extension.dart';
import 'package:pherico_admin_app/widgets/buttons/round_button_with_icon.dart';
import 'package:pherico_admin_app/widgets/global/app_bar.dart';
import 'package:pherico_admin_app/widgets/global/my_progress_indicator.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final TextEditingController _titleController = TextEditingController();
  bool _isLoading = false;
  Uint8List? _selectedImage;
  showToaster(String msg, {bool isError = false}) {
    context.showToast(msg, isError: isError);
  }

  _selectImage() async {
    XFile? pickedImage = await pickImage(ImageSource.gallery, true);

    if (pickedImage != null) {
      Uint8List? croppedFile = await cropImage(pickedImage);
      if (croppedFile != null) {
        setState(() {
          _selectedImage = croppedFile;
        });
      } else {}
    }
  }

  clearImage() {
    if (_selectedImage != null) {
      setState(() {
        _selectedImage!.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(55),
        child: CustomAppbar(
          title: 'Add Category',
          onPressed: () {
            clearImage();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            _selectImage();
                          },
                          child: Container(
                            height: size.height * 0.09,
                            width: size.width * 0.2,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 226, 226, 226),
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/images/icons/camera.svg',
                                height: size.height * 0.06,
                              ),
                            ),
                          ),
                        ),
                        _selectedImage != null
                            ? Container(
                                width: size.width * 0.2,
                                height: size.height * 0.09,
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 226, 226, 226),
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: MemoryImage(_selectedImage!),
                                    fit: BoxFit.cover,
                                    alignment: FractionalOffset.topCenter,
                                  ),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedImage!.clear();
                                    });
                                  },
                                  child: const Align(
                                    alignment: Alignment.topRight,
                                    child: Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: CircleAvatar(
                                        radius: 10,
                                        backgroundColor: Colors.white,
                                        child: Icon(
                                          CupertinoIcons.clear,
                                          size: 15,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('No image selected'),
                              ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    TextFormField(
                      controller: _titleController,
                      autofocus: false,
                      decoration: const InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                  ]),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
                child: _isLoading
                    ? const MyProgressIndicator()
                    : RoundButtonWithIcon(
                        height: 46,
                        buttonName: 'Upload',
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
    if (_titleController.text.isEmpty) {
      showToaster('Enter title', isError: true);
    } else if (_selectedImage == null) {
      showToaster('Select image', isError: true);
    } else {
      setState(() {
        _isLoading = true;
      });
      try {
        bool res = await CategoryResource.postCategory(
            _selectedImage!, _titleController.text.trim());
        if (res) {
          showToaster('Uploaded');
          Get.off(() => const Categories());
        } else {
          showToaster('Something went wrong', isError: true);
        }
      } catch (error) {
        showToaster('Something went wrong', isError: true);
      }
    }
  }
}
