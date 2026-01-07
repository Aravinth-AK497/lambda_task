import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../core/widgets/shimmer_loading_widget.dart';
import '../bloc/user_bloc.dart';
import '../bloc/user_event.dart';
import '../bloc/user_state.dart';
import '../widgets/user_form_dialog.dart';
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
      context.read<UserBloc>().add(const LoadUsers(2));
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _showUserForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const UserFormDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showUserForm(context),
        icon: const Icon(Icons.person_add),
        label: const Text('Add User'),
      ),
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
            context.read<UserBloc>().add(const LoadUsers(1));
          } else if (state is UserError) {
             ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message), 
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          // Because UserLoaded extends UserState, we can check for it. 
          // However, due to state flow, we should be careful. 
          // Let's rely on checking if `users` is available or if we are loading initial.
          
          List<dynamic> users = [];
          bool isLoading = false;
          bool hasReachedMax = false;

          if (state is UserLoading && state is! UserLoaded) {
             return const ShimmerLoadingWidget();
          }
          
          if (state is UserLoaded) {
            users = state.users;
            hasReachedMax = state.hasReachedMax;
          }

          if (users.isEmpty && state is UserLoaded) {
             return Center(
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
                   const SizedBox(height: 16),
                   Text('No users found', style: TextStyle(color: Colors.grey[600], fontSize: 18)),
                 ],
               ),
             );
          }

          if (users.isNotEmpty) {
             return RefreshIndicator(
              onRefresh: () async {
                context.read<UserBloc>().add(const LoadUsers(1));
              },
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.only(bottom: 80), // Space for FAB
                itemCount: hasReachedMax ? users.length : users.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index >= users.length) {
                    return const Center(child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ));
                  } else {
                    final user = users[index];
                    return FadeInUp(
                      duration: const Duration(milliseconds: 300),
                      delay: Duration(milliseconds: index * 50 > 500 ? 0 : index * 50), // Staggered delay for first few items
                      child: Card(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                             Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => UserDetailScreen(user: user)),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Hero(
                                  tag: 'avatar_${user.id}',
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Theme.of(context).colorScheme.secondary, width: 2),
                                    ),
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundImage: NetworkImage(user.avatar),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${user.firstName} ${user.lastName}',
                                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        user.email,
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.error),
                                  onPressed: () {
                                    // Show confirmation dialog logic could go here
                                    context.read<UserBloc>().add(DeleteUserEvent(user.id));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            );
          }

          return const SizedBox.shrink(); 
        },
      ),
    );
  }
}
