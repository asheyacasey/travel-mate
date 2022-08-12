import '../../models/user_model.dart';

abstract class BaseDatabaseRepository {
  Stream<User> getUser(String userId);
  Stream<List<User>> getUsers(String userID, String gender);
  Future<String> createUser(User user);
  Future<void> updateUser(User user);
  Future<void> updateUserPictures(User user, String imageName);
  Future<void> updateUserSwipe(String userId,String matchId, bool isSwipeRight);
}
