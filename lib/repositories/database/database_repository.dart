import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:travel_mate/models/models.dart';
import 'package:travel_mate/repositories/database/base_database_repository.dart';
import 'package:travel_mate/repositories/storage/storage_repository.dart';
import 'dart:math' as math;

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

  Stream<List<User>> getUsers(User user) {
    print('getUsers is running...');
    double userLatitude =
        user.latitude; // Fetch the latitude of the current user from Firestore
    double userLongitude = user
        .longitude; // Fetch the longitude of the current user from Firestore
    double userRadius = user.radius /
        1000; // Fetch the radius of the current user from Firestore

    return _firebaseFirestore
        .collection('users')
        .where('gender', isEqualTo: _selectGender(user))
        .snapshots()
        .map((snap) {
      // Map the documents to User objects and then filter based on interests and location
      List<User> users =
          snap.docs.map((doc) => User.fromSnapshot(doc)).toList();

      List<User> filteredUsers = users.where((currentUser) {
        // Calculate the distance between the current user and each user in the collection
        double distance = calculateDistance(
          userLatitude,
          userLongitude,
          currentUser.latitude,
          currentUser.longitude,
        );

        // Check if the distance is within the maximum radius of the current user
        bool isWithinMaxDistance = distance <= userRadius;

        // Filter based on interests and location
        bool interestMatches = currentUser.interests
            .any((interest) => user.interests.contains(interest));

        print('User ${currentUser.id} interest matches: $interestMatches');
        print(
            'User ${currentUser.id} is within max distance: $isWithinMaxDistance');

        print(
            'User ${currentUser.id} is at a distance of: $distance'); // Print the calculated distance
        print(
            'User ${currentUser.id} max distance: $userRadius'); // Print the user's maximum distance

        // Check if both interestMatches and isWithinMaxDistance are true
        return interestMatches && isWithinMaxDistance;
      }).toList();

      return filteredUsers;
    }).handleError((onError) {
      print('An error occurred: $onError');
    });
  }

// Helper function to calculate the distance between two locations using the Haversine formula
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const int earthRadius = 6371; // Radius of the Earth in kilometers

    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);

    double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) *
            math.cos(_toRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    double distance = earthRadius * c;

    return distance;
  }

  double _toRadians(double degree) {
    return degree * (math.pi / 180);
  }

  Stream<List<User>> getUsersWithMatchingInterests(User user) {
    print('getUsersWithMatchingInterests is running...');
    return _firebaseFirestore
        .collection('users')
        .where('gender', isEqualTo: _selectGender(user))
        .snapshots()
        .map((snap) {
      return snap.docs
          .where((doc) => user.interests.contains(doc.get('interests')))
          .map((doc) => User.fromSnapshot(doc))
          .toList();
    });
  }

  @override
  Stream<List<User>> getUsersToSwipe(User user) {
    return Rx.combineLatest2(getUser(user.id), getUsers(user), (
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
        getUser(user.id), getChats(user.id), getUsers(user), (
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

        return Match(userId: user.id, matchUser: matchUser, chat: chat);
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
  Future<void> updateMessage(
      String chatId, Message message, String oldMessageId) async {
    print("UPDATING ID ===>>" + message.messageId);
    print("DELETING ID ===>>" + message.messageId);

    DocumentReference docRef =
        _firebaseFirestore.collection('chats').doc(chatId);

    try {
      DocumentSnapshot doc = await docRef.get();

      if (doc.exists) {
        // Retrieve the array from the document
        List<dynamic> chatsArray = doc.get('messages');

        // Find the index of the element with matching messageId
        int indexToDelete =
            chatsArray.indexWhere((chat) => chat['messageId'] == oldMessageId);
        print("DELETING THE ID ===>>" + oldMessageId);

        if (indexToDelete != -1) {
          // Remove the element from the array
          chatsArray.removeAt(indexToDelete);

          // Update the document with the modified array
          await docRef.update({'messages': chatsArray});
          print('Element deleted successfully.');
        } else {
          print('Element not found in the array.');
        }
      } else {
        print('Document not found.');
      }
    } catch (error) {
      print('Error retrieving or updating document: $error');
    }

    await _firebaseFirestore.collection('chats').doc(chatId).update({
      'messages': FieldValue.arrayUnion([
        message.toJson(),
      ])
    });
  }

  @override
  Future<void> deleteMessage(String chatId, Message message) async {
    DocumentReference docRef =
        _firebaseFirestore.collection('chats').doc(chatId);

    docRef.get().then((doc) {
      if (doc.exists) {
        // Retrieve the array from the document
        List<dynamic> chatsArray = doc.get('messages');

        // Find the index of the element with matching messageId
        int indexToDelete = chatsArray
            .indexWhere((chat) => chat['messageId'] == message.messageId);
        print("DELETING ID ===>>" + message.messageId);

        if (indexToDelete != -1) {
          // Remove the element from the array
          chatsArray.removeAt(indexToDelete);

          // Update the document with the modified array
          return docRef.update({'messages': chatsArray}).then((_) {
            print('Element deleted successfully.');
          }).catchError((error) {
            print('Error updating document: $error');
          });
        } else {
          print('Element not found in the array.');
        }
      } else {
        print('Document not found.');
      }
    // ignore: body_might_complete_normally_catch_error
    }).catchError((error) {
      print('Error retrieving document: $error');
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
