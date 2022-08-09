import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:travel_mate/repositories/storage/base_storage_repository.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class StorageRepository extends BaseStorageRepository {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  @override
  Future<void> uploadImage(XFile image) async {
    try {
      await storage.ref('user_1/${image.name}').putFile(
            File(image.path),
          );
    } catch (_) {}
  }
}
