import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class GetUsers implements UseCase<List<User>, GetUsersParams> {
  final UserRepository repository;

  GetUsers(this.repository);

  @override
  Future<Either<Failure, List<User>>> call(GetUsersParams params) async {
    return await repository.getUsers(params.page);
  }
}

class GetUsersParams extends Equatable {
  final int page;
  const GetUsersParams({required this.page});

  @override
  List<Object?> get props => [page];
}
