import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class LoadUsers extends UserEvent {
  final int page;
  const LoadUsers(this.page);

  @override
  List<Object> get props => [page];
}

class CreateUserEvent extends UserEvent {
  final String name;
  final String job;

  const CreateUserEvent({required this.name, required this.job});

  @override
  List<Object> get props => [name, job];
}

class UpdateUserEvent extends UserEvent {
  final int id;
  final String name;
  final String job;

  const UpdateUserEvent({required this.id, required this.name, required this.job});

  @override
  List<Object> get props => [id, name, job];
}

class DeleteUserEvent extends UserEvent {
  final int id;

  const DeleteUserEvent(this.id);

  @override
  List<Object> get props => [id];
}
