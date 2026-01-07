import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_user.dart';
import '../../domain/usecases/delete_user.dart';
import '../../domain/usecases/get_users.dart';
import '../../domain/usecases/update_user.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUsers getUsers;
  final CreateUser createUser;
  final UpdateUser updateUser;
  final DeleteUser deleteUser;

  UserBloc({
    required this.getUsers,
    required this.createUser,
    required this.updateUser,
    required this.deleteUser,
  }) : super(UserInitial()) {
    on<LoadUsers>(_onLoadUsers);
    on<CreateUserEvent>(_onCreateUser);
    on<UpdateUserEvent>(_onUpdateUser);
    on<DeleteUserEvent>(_onDeleteUser);
  }

  Future<void> _onLoadUsers(LoadUsers event, Emitter<UserState> emit) async {
    if (state is UserLoading) return;
    
    final currentState = state;
    var currentUsers = <dynamic>[]; // Use dynamic temporarily to match User type later or explicit
    int nextPage = 1;

    if (currentState is UserLoaded) {
      if (currentState.hasReachedMax && event.page != 1) return; // Allow refresh (page 1) even if max reached
      currentUsers = currentState.users;
      nextPage = event.page;
    } else {
      emit(UserLoading());
    }

    final result = await getUsers(GetUsersParams(page: nextPage));

    result.fold(
      (failure) => emit(UserError(failure.message)),
      (users) {
        if (users.isEmpty) {
          if (currentState is UserLoaded) {
            emit(currentState.copyWith(hasReachedMax: true));
          } else {
             emit(UserLoaded(users: [], hasReachedMax: true, currentPage: nextPage));
          }
        } else {
          // If refreshing (page 1), replace list. Else append.
          final newUsers = nextPage == 1 ? users : (List.of(currentUsers)..addAll(users));
          emit(UserLoaded(
            users: newUsers.cast(), // Ensure type safety
            hasReachedMax: users.length < 6, // ReqRes usually 6 per page
            currentPage: nextPage,
          ));
        }
      },
    );
  }

  Future<void> _onCreateUser(CreateUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final result = await createUser(CreateUserParams(name: event.name, job: event.job));
    result.fold(
      (failure) => emit(UserError(failure.message)),
      (user) {
        emit(const UserOperationSuccess("User Created Successfully"));
        // Ideally reload users or add to list locally. 
        // For simplicity, just success state which UI listens to and then triggers reload.
      },
    );
  }

  Future<void> _onUpdateUser(UpdateUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final result = await updateUser(UpdateUserParams(id: event.id, name: event.name, job: event.job));
    result.fold(
      (failure) => emit(UserError(failure.message)),
      (user) {
        emit(const UserOperationSuccess("User Updated Successfully"));
      },
    );
  }

  Future<void> _onDeleteUser(DeleteUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final result = await deleteUser(DeleteUserParams(id: event.id));
    result.fold(
      (failure) => emit(UserError(failure.message)),
      (_) {
        emit(const UserOperationSuccess("User Deleted Successfully"));
      },
    );
  }
}
