import 'package:myapp/domain/models/user/user.dart';
import 'package:myapp/domain/repository/base_repo.dart';

abstract class AuthRepo extends BaseRepo {
  Future<bool> isSignedIn();
  Future<User> getUser();
}
