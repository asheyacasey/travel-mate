import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_mate/repositories/storage/storage_repository.dart';

class CustomImageContainer extends StatelessWidget {
  final TabController tabController;

  const CustomImageContainer({
    Key? key,
    required this.tabController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 10.0, right: 10.0),
        child: Container(
          height: 150,
          width: 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border(
                bottom:
                    BorderSide(color: Theme.of(context).primaryColor, width: 1),
                top:
                    BorderSide(color: Theme.of(context).primaryColor, width: 1),
                left:
                    BorderSide(color: Theme.of(context).primaryColor, width: 1),
                right:
                    BorderSide(color: Theme.of(context).primaryColor, width: 1),
              )),
          child: Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              icon:
                  Icon(Icons.add_circle, color: Theme.of(context).primaryColor),
              onPressed: () async {
                ImagePicker _picker = ImagePicker();
                final XFile? _image =
                    await _picker.pickImage(source: ImageSource.gallery);

                if (_image == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('No image was selected.'),
                    ),
                  );

                  if (_image != null) {
                    print('Uploading...');
                    StorageRepository().uploadImage(_image);
                  }
                }
              },
            ),
          ),
        ));
  }
}
