import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_mate/models/user_model.dart';
import 'package:travel_mate/repositories/database/base_database_repository.dart';
import 'package:travel_mate/repositories/storage/storage_repository.dart';

class DatabaseRepository extends BaseDatabaseRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Stream<User> getUser() {
    return _firebaseFirestore
        .collection('users')
        .doc('6cz2rEWKV8NTUj93WtKT')
        .snapshots()
        .map((snap) => User.fromSnapshot(snap));
  }

  @override
  Future<void> updateUserPictures(String imageName) async {
    String downloadUrl = await StorageRepository().getDownloadURL(imageName);

    return _firebaseFirestore
        .collection('users')
        .doc('6cz2rEWKV8NTUj93WtKT')
        .update({
      'imageUrls': FieldValue.arrayUnion([downloadUrl]),
    });
  }
}
