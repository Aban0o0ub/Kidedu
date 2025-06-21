import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class HeaderImage extends StatefulWidget {
  const HeaderImage({super.key});

  @override
  State<HeaderImage> createState() => _HeaderImageState();
}

class _HeaderImageState extends State<HeaderImage> {
  File? _pickedImage;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: _pickImage,
        borderRadius: BorderRadius.circular(50),
        child: Container(
          height: 330,
          width: 430,
          decoration: const BoxDecoration(
            color: Color(0xffB7B7B7),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
          child: Center(
            child: _pickedImage == null
                ? const Image(
                    image: AssetImage('assets/images/CourseDefaultPhoto.jpeg'),
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    _pickedImage!,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      ),
    );
  }
}
