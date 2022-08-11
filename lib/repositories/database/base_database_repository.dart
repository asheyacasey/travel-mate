import '../../models/user_model.dart';

abstract class BaseDatabaseRepository {
  Stream<User> getUser();
  Future<String> createUser(User user);
  Future<void> updateUser(User user);
  Future<void> updateUserPictures(User user, String imageName);
}
