import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pherico_admin_app/config/firebase_constants.dart';
import 'package:pherico_admin_app/config/my_color.dart';
import 'package:pherico_admin_app/models/authors.dart';
import 'package:pherico_admin_app/resources/blog_resource.dart';
import 'package:pherico_admin_app/utils/crop_image.dart';
import 'package:pherico_admin_app/utils/pick_image.dart';
import 'package:pherico_admin_app/utils/toast_extension.dart';
import 'package:pherico_admin_app/widgets/buttons/round_button_with_icon.dart';
import 'package:pherico_admin_app/widgets/global/app_bar.dart';
import 'package:pherico_admin_app/widgets/global/my_progress_indicator.dart';

class AddBlog extends StatefulWidget {
  const AddBlog({super.key});

  @override
  State<AddBlog> createState() => _AddBlogState();
}

class _AddBlogState extends State<AddBlog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  final TextEditingController _desc1Controller = TextEditingController();
  final TextEditingController _desc2Controller = TextEditingController();
  final List<Uint8List> _selectedImages = [];
  List<Author> authors = [];
  Author? _selectedAuthor;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    getAuthor();
  }

  getAuthor() async {
    QuerySnapshot snapshot =
        await firebaseFirestore.collection('authors').get();
    for (var element in snapshot.docs) {
      authors
          .add(Author(author: element['author'], profile: element['profile']));
    }
    _selectedAuthor = authors[0];
    setState(() {});
  }

  clearImage() {
    setState(() {
      _selectedImages.clear();
    });
  }

  _selectImage() async {
    XFile? pickedImage = await pickImage(ImageSource.gallery, true);

    if (pickedImage != null) {
      Uint8List? croppedFile = await cropProductImage(pickedImage);
      if (croppedFile != null) {
        setState(() {
          _selectedImages.insert(0, croppedFile);
        });
      } else {}
    }
  }

  showToaster(String msg, {bool isError = false}) {
    context.showToast(msg, isError: isError);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(55),
        child: CustomAppbar(
          title: 'Add blog',
          onPressed: () {
            clearImage();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            if (_selectedImages.length >= 2) {
                              showToaster('Allow only 2 image');
                            } else {
                              _selectImage();
                            }
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
                        _selectedImages.isNotEmpty
                            ? SizedBox(
                                height: size.height * 0.112,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 6, left: 12),
                                  child: Expanded(
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      padding:
                                          const EdgeInsets.only(bottom: 12),
                                      shrinkWrap: true,
                                      itemCount: _selectedImages.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          width: size.width * 0.2,
                                          height: size.height * 0.09,
                                          margin:
                                              const EdgeInsets.only(right: 8),
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 226, 226, 226),
                                            shape: BoxShape.rectangle,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            image: DecorationImage(
                                              image: MemoryImage(
                                                  _selectedImages[index]),
                                              fit: BoxFit.cover,
                                              alignment:
                                                  FractionalOffset.topCenter,
                                            ),
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                _selectedImages.removeAt(index);
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
                                        );
                                      },
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
                    DropdownButton<Author>(
                      isExpanded: true,
                      value: _selectedAuthor,
                      hint: const Text('Select author'),
                      borderRadius: BorderRadius.circular(10),
                      dropdownColor: inputBoxColor,
                      underline: const SizedBox(),
                      onChanged: (Author? newValue) {
                        setState(() {
                          _selectedAuthor = newValue!;
                        });
                      },
                      items: authors
                          .map<DropdownMenuItem<Author>>((Author option) {
                        return DropdownMenuItem<Author>(
                          value: option,
                          child: Text(option.author),
                        );
                      }).toList(),
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
                    TextFormField(
                      controller: _tagsController,
                      autofocus: false,
                      decoration: const InputDecoration(labelText: 'Tags'),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    TextField(
                      controller: _desc1Controller,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 25,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextField(
                      controller: _desc2Controller,
                      decoration: const InputDecoration(
                          labelText: 'Another description'),
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 25,
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
                      buttonName: 'Upload',
                      onPressed: () {
                        handleSubmit();
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  handleSubmit() async {
    if (_titleController.text.isEmpty) {
      showToaster('Please enter title');
    } else if (_tagsController.text.isEmpty) {
      showToaster('Enter tags');
    } else if (_desc1Controller.text.isEmpty) {
      showToaster('Enter some desciption');
    } else if (_selectedImages.isEmpty) {
      showToaster('Please select image');
    } else {
      setState(() {
        _isLoading = true;
      });
      bool res = await BlogResource.uploadBlog(
        _selectedAuthor!.author,
        _selectedAuthor!.profile,
        _titleController.text,
        _tagsController.text,
        _desc1Controller.text,
        _desc2Controller.text,
        _selectedImages,
      );
      if (res) {
        showToaster('Uploaded successfully');
      } else {
        showToaster('Error', isError: true);
      }
      setState(() {
        _isLoading = false;
      });
      Get.back();
    }
  }
}
