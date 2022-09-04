import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class ProfilePhoto extends StatefulWidget {
  const ProfilePhoto({Key? key}) : super(key: key);

  @override
  State<ProfilePhoto> createState() => _ProfilePhotoState();
}

class _ProfilePhotoState extends State<ProfilePhoto> {
  File? image;

  //Access Gallery for photo
  Future<File?> _pickImageGallery() async {
    PickedFile? pickedFile =
        // ignore: invalid_use_of_visible_for_testing_member
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      return null;
    }
    final File file = File(pickedFile.path);
    final Directory directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final String fileName = basename(pickedFile.path);
    //final String fileExtension = extension(image.path);
    File newImage = await file.copy('$path/$fileName');
    setState(() {
      image = newImage;
    });
    return null;
  }

  //Access camera to take photo for profile.
  void _pickImageCamera() async {
    final picker = ImagePicker();
    XFile? pickedImage = await picker.pickImage(source: ImageSource.camera);
    final imageTemp = File(pickedImage!.path);
    setState(() => image = imageTemp);
    // ignore: use_build_context_synchronously
    // Navigator.pop(context);
  }

  void _remove() {
    setState(() {
      image = null;
    });
    // ignore: use_build_context_synchronously
    // Navigator.pop(context);
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
              const CircleAvatar(
                backgroundImage: AssetImage('assets/images/Profile_Image.png'),
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
                          side: const BorderSide(color: Colors.white),
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
