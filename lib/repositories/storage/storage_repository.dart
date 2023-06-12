import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:travel_mate/repositories/database/database_repository.dart';
import 'package:travel_mate/repositories/storage/base_storage_repository.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../../models/models.dart';

class StorageRepository extends BaseStorageRepository {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  @override
  Future<String> uploadImage(User user, XFile image) async {
    try {
      await storage.ref('${user.id}/${image.name}').putFile(File(image.path));
      String downloadURL = await getDownloadURL(user, image.name);
      return downloadURL;
    } catch (e) {
      print('Error occurred while uploading image: $e');
      throw e;  // Propagate the exception to the caller
    }
  }

  @override
  Future<String> getDownloadURL(User user, String imageName) async {
    String downloadURL =
    await storage.ref('${user.id}/$imageName').getDownloadURL();

    return downloadURL;
  }
}

