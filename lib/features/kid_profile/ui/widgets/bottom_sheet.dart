import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
Widget bottomSheet(BuildContext context,Function(ImageSource) takePhoto) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    child: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min, 
        children: <Widget>[
          const Text(
            'Choose profile photo',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center, 
            children: <Widget>[
              Column(
                children: [
                  IconButton(
                    onPressed: () {
                      takePhoto(ImageSource.camera);
                    },
                    icon: const Icon(Icons.camera),
                  ),
                  const Text("Camera"),
                ],
              ),
              const SizedBox(width: 20),
              Column(
                children: [
                  IconButton(
                    onPressed: () {
                      takePhoto(ImageSource.gallery);
                    },
                    icon: const Icon(Icons.image),
                  ),
                  const Text("Gallery"),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
 
  );
}

