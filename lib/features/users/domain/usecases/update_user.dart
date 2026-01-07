import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class UpdateUser implements UseCase<User, UpdateUserParams> {
  final UserRepository repository;

  UpdateUser(this.repository);

  @override
  Future<Either<Failure, User>> call(UpdateUserParams params) async {
    return await repository.updateUser(params.id, params.name, params.job);
  }
}

class UpdateUserParams extends Equatable {
  final int id;
  final String name;
  final String job;

  const UpdateUserParams({required this.id, required this.name, required this.job});

  @override
  List<Object?> get props => [id, name, job];
}
