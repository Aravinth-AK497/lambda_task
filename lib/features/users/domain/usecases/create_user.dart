import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class CreateUser implements UseCase<User, CreateUserParams> {
  final UserRepository repository;

  CreateUser(this.repository);

  @override
  Future<Either<Failure, User>> call(CreateUserParams params) async {
    return await repository.createUser(params.name, params.job);
  }
}

class CreateUserParams extends Equatable {
  final String name;
  final String job;

  const CreateUserParams({required this.name, required this.job});

  @override
  List<Object?> get props => [name, job];
}
