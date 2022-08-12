import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_mate/models/user_model.dart';
import 'package:travel_mate/repositories/database/base_database_repository.dart';
import 'package:travel_mate/repositories/storage/storage_repository.dart';

class DatabaseRepository extends BaseDatabaseRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Stream<User> getUser(String userId) {
    return _firebaseFirestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((snap) => User.fromSnapshot(snap));
  }

  @override
  Future<void> updateUserPictures(User user, String imageName) async {
    String downloadUrl =
        await StorageRepository().getDownloadURL(user, imageName);

    return _firebaseFirestore.collection('users').doc(user.id).update({
      'imageUrls': FieldValue.arrayUnion([downloadUrl]),
    });
  }

  @override
  Future<String> createUser(User user) async {
    String documentId = await _firebaseFirestore
        .collection('users')
        .add(user.toMap())
        .then((value) {
      print('User add, ID: ${value.id}');
      return value.id;
    });

    return documentId;
  }

  @override
  Future<void> updateUser(User user) {
    return _firebaseFirestore
        .collection('users')
        .doc(user.id)
        .update(user.toMap())
        .then((value) => print('User document updated.'));
  }

  @override
  Stream<List<User>> getUsers(User user) {
    List<String> userFilter = List.from(user.swipeLeft!)
    ..addAll(user.swipeRight!)
    ..add(user.id!);

    return _firebaseFirestore
        .collection('users')
        .where('gender', isEqualTo: 'Female')
        .where(FieldPath.documentId, whereNotIn: userFilter )
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map(
              (doc) => User.fromSnapshot(doc),
            )
            .toList());
  }
}
