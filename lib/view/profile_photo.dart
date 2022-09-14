import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePhoto extends StatefulWidget {
  const ProfilePhoto({Key? key}) : super(key: key);

  @override
  State<ProfilePhoto> createState() => _ProfilePhotoState();
}

class _ProfilePhotoState extends State<ProfilePhoto> {
  File? _pickedImage;
  final _profileDefaultPhoto =
      Image.asset('assets/images/Profile_Image.png').image;

  void _pickImageGallery() async {
    XFile? pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return;
    final imageTemp = File(pickedImage.path);
    setState(() => _pickedImage = imageTemp);
  }

  //Access camera to take photo for profile.
  void _pickImageCamera() async {
    final picker = ImagePicker();
    XFile? pickedImage = await picker.pickImage(source: ImageSource.camera);
    final imageTemp = File(pickedImage!.path);
    setState(() => _pickedImage = imageTemp);
  }

  //Remove Photo from avatar
  void _remove() {
    setState(() {
      _pickedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 115,
          width: 115,
          child: Stack(
            fit: StackFit.expand,
            clipBehavior: Clip.none,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 1,
                  horizontal: 1,
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.blueGrey[700],
                  child: CircleAvatar(
                    radius: 52,
                    //backgroundColor: Colors.white,
                    // backgroundImage: AssetImage('assets/images/Profile_Image.png')
                    backgroundImage: _pickedImage == null
                        ? _profileDefaultPhoto
                        : FileImage(_pickedImage!),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: -3,
                child: SizedBox(
                  height: 46,
                  width: 46,
                  child: TextButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                          side: const BorderSide(color: Colors.black38),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                    //Access camera or choose photo from device.
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text(
                              'Choose Option',
                            ),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: [
                                  InkWell(
                                    onTap: _pickImageCamera,
                                    child: Row(
                                      children: const [
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.camera,
                                          ),
                                        ),
                                        Text('Camera')
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: _pickImageGallery,
                                    child: Row(
                                      children: const [
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.image,
                                          ),
                                        ),
                                        Text('Gallery')
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: _remove,
                                    child: Row(
                                      children: const [
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child:
                                              Icon(Icons.remove_circle_outline),
                                        ),
                                        Text('Remove Photo')
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: SvgPicture.asset('assets/icons/Camera_Icon.svg'),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
