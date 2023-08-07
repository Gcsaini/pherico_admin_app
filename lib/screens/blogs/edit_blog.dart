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
import 'package:pherico_admin_app/models/blogs.dart';
import 'package:pherico_admin_app/resources/blog_resource.dart';
import 'package:pherico_admin_app/resources/storage_methods.dart';
import 'package:pherico_admin_app/utils/crop_image.dart';
import 'package:pherico_admin_app/utils/pick_image.dart';
import 'package:pherico_admin_app/utils/toast_extension.dart';
import 'package:pherico_admin_app/widgets/buttons/round_button_with_icon.dart';
import 'package:pherico_admin_app/widgets/global/app_bar.dart';
import 'package:pherico_admin_app/widgets/global/my_progress_indicator.dart';
import 'package:uuid/uuid.dart';

class EditBlog extends StatefulWidget {
  Blog blog;
  EditBlog({super.key, required this.blog});

  @override
  State<EditBlog> createState() => _EditBlogState();
}

class _EditBlogState extends State<EditBlog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  final TextEditingController _desc1Controller = TextEditingController();
  final TextEditingController _desc2Controller = TextEditingController();
  final List<Uint8List> _selectedImages = [];
  List<Author> authors = [];
  Author? _selectedAuthor;
  bool _isLoading = false;
  String image1 = '';
  String image2 = '';

  @override
  void initState() {
    super.initState();
    getAuthor();
    _titleController.text = widget.blog.title;
    _tagsController.text = widget.blog.tags;
    _desc1Controller.text = widget.blog.desc1;
    _desc2Controller.text = widget.blog.desc2;
    image1 = widget.blog.image1;
    image2 = widget.blog.image2;
  }

  getAuthor() async {
    QuerySnapshot snapshot =
        await firebaseFirestore.collection('authors').get();
    for (var element in snapshot.docs) {
      authors
          .add(Author(author: element['author'], profile: element['profile']));
    }
    for (var element in authors) {
      if (element.author == widget.blog.author) {
        _selectedAuthor = element;
      }
    }
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
          title: 'Edit blog',
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
                            } else if (image1.isNotEmpty && image2.isNotEmpty) {
                              showToaster('Only 2 image allowed');
                            } else if (_selectedImages.length == 1 &&
                                image1.isNotEmpty) {
                              showToaster('Only 2 image allowed');
                            } else if (_selectedImages.length == 1 &&
                                image2.isNotEmpty) {
                              showToaster('Only 2 image allowed');
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
                            : Container(),
                        const SizedBox(
                          width: 8,
                        ),
                        image1.isNotEmpty
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
                                    image: NetworkImage(widget.blog.image1),
                                    fit: BoxFit.cover,
                                    alignment: FractionalOffset.topCenter,
                                  ),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      image1 = '';
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
                            : Container(),
                        const SizedBox(
                          width: 8,
                        ),
                        image2.isNotEmpty
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
                                    image: NetworkImage(widget.blog.image2),
                                    fit: BoxFit.cover,
                                    alignment: FractionalOffset.topCenter,
                                  ),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      image2 = '';
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
                            : Container(),
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
    } else if (image1.isEmpty && image2.isEmpty && _selectedImages.isEmpty) {
      showToaster('Please select image');
    } else {
      setState(() {
        _isLoading = true;
      });
      String newImage1 = '';
      String newImage2 = '';
      if (_selectedImages.length == 2) {
        List<String> imageUrls = [];
        for (var image in _selectedImages) {
          Uint8List imageData = await compressImage(image);
          String child = const Uuid().v1();
          String imageUrl = await uploadImage(child, imageData, 'blogs');
          imageUrls.add(imageUrl);
        }
        newImage1 = imageUrls[0];
        newImage2 = imageUrls[1];
      } else if (_selectedImages.length == 1 && image1.isNotEmpty) {
        Uint8List imageData = await compressImage(_selectedImages[0]);
        String child = const Uuid().v1();
        newImage2 = await uploadImage(child, imageData, 'blogs');
        newImage1 = widget.blog.image1;
      } else if (_selectedImages.length == 1 && image2.isNotEmpty) {
        Uint8List imageData = await compressImage(_selectedImages[0]);
        String child = const Uuid().v1();
        newImage1 = await uploadImage(child, imageData, 'blogs');
        newImage2 = widget.blog.image2;
      } else if (_selectedImages.isEmpty) {
        newImage1 = widget.blog.image1;
        newImage2 = widget.blog.image2;
      } else if (image1.isEmpty && image2.isEmpty) {
        print('here');
        List<String> imageUrls = [];
        for (var image in _selectedImages) {
          Uint8List imageData = await compressImage(image);
          String child = const Uuid().v1();
          String imageUrl = await uploadImage(child, imageData, 'blogs');
          imageUrls.add(imageUrl);
        }
        if (imageUrls.length == 2) {
          newImage1 = imageUrls[0];
          newImage2 = imageUrls[1];
        } else {
          newImage1 = imageUrls[0];
          newImage2 = '';
        }
      }
      bool res = await BlogResource.updateBlog(
          _selectedAuthor!.author,
          _selectedAuthor!.profile,
          _titleController.text,
          _tagsController.text,
          _desc1Controller.text,
          _desc2Controller.text,
          newImage1,
          newImage2,
          widget.blog.id);
      if (res) {
        showToaster('Updated successfully');
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
