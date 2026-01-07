import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, List<User>>> getUsers(int page);
  Future<Either<Failure, User>> createUser(String name, String job);
  Future<Either<Failure, User>> updateUser(int id, String name, String job);
  Future<Either<Failure, void>> deleteUser(int id);
}
