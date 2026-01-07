import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/user_bloc.dart';
import '../bloc/user_event.dart';
import '../bloc/user_state.dart';
import 'user_form_screen.dart';
import 'user_detail_screen.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<UserBloc>().add(const LoadUsers(1));
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<UserBloc>().add(const LoadUsers(2)); // Simplified: Increment logic needed or use current page from state
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const UserFormScreen()),
          ).then((_) {
            // Reload logic if needed, or BLoC handles state
          });
        },
        child: const Icon(Icons.add),
      ),
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            // Reload users to reflect changes
             context.read<UserBloc>().add(const LoadUsers(1));
          } else if (state is UserError) {
             ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          if (state is UserLoading && state is! UserLoaded) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is UserLoaded) {
             if (state.users.isEmpty) {
              return const Center(child: Text('No users found.'));
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<UserBloc>().add(const LoadUsers(1));
              },
              child: ListView.builder(
                controller: _scrollController,
                itemCount: state.hasReachedMax
                    ? state.users.length
                    : state.users.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index >= state.users.length) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    final user = state.users[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(user.avatar),
                        ),
                        title: Text('${user.firstName} ${user.lastName}'),
                        subtitle: Text(user.email),
                        onTap: () {
                           Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => UserDetailScreen(user: user)),
                          );
                        },
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                             context.read<UserBloc>().add(DeleteUserEvent(user.id));
                          },
                        ),
                      ),
                    );
                  }
                },
              ),
            );
          }
          
          return const Center(child: Text('Start by loading users'));
        },
      ),
    );
  }
}
