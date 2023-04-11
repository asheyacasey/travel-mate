import 'package:travel_mate/blocs/blocs.dart';

import '../../models/models.dart';

abstract class BaseDatabaseRepository {
  Stream<User> getUser(String userId);
  Stream<List<User>> getUsersToSwipe(User user);
  Stream<List<User>> getUsers(User user); // <-- String userId, String gender
  Stream<List<Match>> getMatches(User user);
  Future<void> createUser(User user);
  Future<void> updateUser(User user);
  Future<void> UpdateUserInterest(User user, String? interest);
  Future<void> updateUserPictures(User user, String imageName);
  Future<void> updateUserSwipe(
      String userId, String matchId, bool isSwipeRight);
  Future<void> updateUserMatch(String userId, String matchId);
}
