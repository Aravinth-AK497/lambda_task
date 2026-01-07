import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';

abstract class UserState extends Equatable {
  const UserState();
  
  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<User> users;
  final bool hasReachedMax;
  final int currentPage;

  const UserLoaded({
    required this.users,
    this.hasReachedMax = false,
    required this.currentPage,
  });

  UserLoaded copyWith({
    List<User>? users,
    bool? hasReachedMax,
    int? currentPage,
  }) {
    return UserLoaded(
      users: users ?? this.users,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object> get props => [users, hasReachedMax, currentPage];
}

class UserOperationSuccess extends UserState {
  final String message;
  const UserOperationSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class UserError extends UserState {
  final String message;
  const UserError(this.message);

  @override
  List<Object> get props => [message];
}
