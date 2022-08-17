import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:travel_mate/models/models.dart';
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
  Stream<List<User>> getUsers(User user) {
    return _firebaseFirestore
        .collection('users')
        .where('gender', isEqualTo: _selectGender(user))
        .snapshots()
        .map((snap) {
      return snap.docs.map((doc) => User.fromSnapshot(doc)).toList();
    });
  }

  @override
  Stream<List<User>> getUsersToSwipe(User user) {
    return Rx.combineLatest2(getUser(user.id!), getUsers(user), (
        User currentUser,
        List<User> users,
        ) {
      return users.where((user){
        if(currentUser.swipeLeft!.contains(user.id)){
          return false;
        } else if (currentUser.swipeRight!.contains(user.id)){
          return false;
        } else if (currentUser.matches!.contains(user.id)){
          return false;
        } else {
          return true;
        }
      }).toList();
    });
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
  Future<void> createUser(User user) async {
    await _firebaseFirestore.collection('users').doc(user.id).set(user.toMap());
  }

  @override
  Future<void> updateUser(User user) {
    return _firebaseFirestore
        .collection('users')
        .doc(user.id)
        .update(user.toMap())
        .then((value) => print('User document updated.'));
  }


  // this is the old getUser

  // @override
  // Stream<List<User>> getUsers(
  //     User user,
  //     ) {
  //   List<String> userFilter = List.from(user.swipeLeft!)
  //     ..addAll(user.swipeRight!)
  //     ..add(user.id!);
  //
  //   return _firebaseFirestore
  //       .collection('users')
  //       .where('gender', isEqualTo: 'Female')
  //       .where(FieldPath.documentId, whereNotIn: userFilter)
  //       .snapshots()
  //       .map((snap) {
  //     return snap.docs.map((doc) => User.fromSnapshot(doc)).toList();
  //   });
  // }

  @override
  Future<void> updateUserSwipe(
      String userId, String matchId, bool isSwipeRight) async {
    if (isSwipeRight) {
      await _firebaseFirestore.collection('users').doc(userId).update({
        'swipeRight': FieldValue.arrayUnion([matchId])
      });
    } else {
      await _firebaseFirestore.collection('users').doc(userId).update({
        'swipeLeft': FieldValue.arrayUnion([matchId])
      });
    }
  }

  @override
  Future<void> updateUserMatch(String userId, String matchId) async {
    // Update the current user document
    await _firebaseFirestore.collection('users').doc(userId).update({
      'matches': FieldValue.arrayUnion([matchId])
    });
    // Add the match in the other user document too.
    await _firebaseFirestore.collection('users').doc(matchId).update({
      'matches': FieldValue.arrayUnion([userId])
    });
  }

  @override
  Stream<List<Match>> getMatches(User user) {

    return Rx.combineLatest2(getUser(user.id!), getUsers(user), (
        User currentUser,
        List<User> users,
        ) {
        return users
            .where((user) => currentUser.matches!.contains(user.id))
            .map((user) => Match(userId: user.id!, matchedUser: user))
            .toList();
    }
    );

    // return _firebaseFirestore
    //     .collection('users')
    //     .snapshots()
    //     .map((snap) {
    //   return snap.docs
    //       .map(
    //         (doc) => Match.fromSnapshot(doc, user.id!),
    //       )
    //       .toList();
    // });
  }

  _selectGender(User user) {
    return (user.gender == 'Female') ? 'Male' : 'Female';
  }
}
