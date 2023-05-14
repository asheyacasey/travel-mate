import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:travel_mate/blocs/blocs.dart';
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

  @override
  Future<void> UpdateUserInterest(User user, String? interest) async {
    final docRef = _firebaseFirestore.collection('users').doc(user.id);
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      final currentInterests = List<String>.from(docSnapshot.get('interests'));

      if (currentInterests.contains(interest)) {
        await docRef.update({
          'interests': FieldValue.arrayRemove([interest])
        });
        print('Removed $interest from interests of user ${user.id}');
      } else {
        await docRef.update({
          'interests': FieldValue.arrayUnion([interest])
        });
        print('Added $interest to interests of user ${user.id}');
      }
    }
  }

  @override
  Stream<List<User>> getUsers(
    User user,
  ) {
    // List<String> userFilter = List.from(user.swipeLeft!)
    //   ..addAll(user.swipeRight!)
    //   ..add(user.id!);
    return _firebaseFirestore
        .collection('users')
        // .where('gender', isEqualTo: 'Female')
        // .where(FieldPath.documentId, whereNotIn: userFilter)
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
      return users.where((user) {
        if (currentUser.swipeLeft!.contains(user.id)) {
          return false;
        } else if (currentUser.swipeRight!.contains(user.id)) {
          return false;
        } else if (currentUser.matches!.contains(user.id)) {
          return false;
        } else {
          return true;
        }
      }).toList();
    });
  }

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
    String chatId = await _firebaseFirestore.collection('chats').add({
      'userIds': [userId, matchId],
      'messages': [],
    }).then((value) => value.id);

    // Update the current user document
    await _firebaseFirestore.collection('users').doc(userId).update({
      'matches': FieldValue.arrayUnion([
        {
          'matchId': matchId,
          'chatId': chatId,
        }
      ])
    });
    // Add the match in the other user document too.
    await _firebaseFirestore.collection('users').doc(matchId).update({
      'matches': FieldValue.arrayUnion([
        {
          'matchId': userId,
          'chatId': chatId,
        }
      ])
    });
  }

  @override
  Stream<List<Match>> getMatches(User user) {
    return Rx.combineLatest3(
        getUser(user.id!), getChats(user.id!), getUsers(user), (
      User user,
      List<Chat> userChats,
      List<User> otherUsers,
    ) {
      return otherUsers.where((otherUser) {
        List<String> matches =
            user.matches!.map((match) => match['matchId'] as String).toList();
        return matches.contains(otherUser.id);
      }).map((matchUser) {
        Chat chat = userChats.where((chat) {
          return chat.userIds.contains(matchUser.id) &
              chat.userIds.contains(user.id);
        }).first;

        return Match(userId: user.id!, matchUser: matchUser, chat: chat);
      }).toList();
    });
  }

  _selectGender(User user) {
    return (user.gender == 'Female') ? 'Male' : 'Female';
  }

  @override
  Future<void> addMessage(String chatId, Message message) {
    return _firebaseFirestore.collection('chats').doc(chatId).update({
      'messages': FieldValue.arrayUnion([
        message.toJson(),
      ])
    });
  }

  @override
  Future<void> updateMessage(String chatId, Message message) {
    return _firebaseFirestore.collection('chats').doc(chatId).update({
      'messages': FieldValue.arrayUnion([
        message.toJson(),
      ])
    });
  }

  @override
  Stream<Chat> getChat(String chatId) {
    return _firebaseFirestore.collection('chats').doc(chatId).snapshots().map(
        (doc) => Chat.fromJson(doc.data() as Map<String, dynamic>, id: doc.id));
  }

  @override
  Stream<List<Chat>> getChats(String userId) {
    return _firebaseFirestore
        .collection('chats')
        .where('userIds', arrayContains: userId)
        .snapshots()
        .map((snap) {
      return snap.docs
          .map((doc) => Chat.fromJson(doc.data(), id: doc.id))
          .toList();
    });
  }
}
