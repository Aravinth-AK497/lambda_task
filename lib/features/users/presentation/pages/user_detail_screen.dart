import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../domain/entities/user.dart';
import '../widgets/user_form_dialog.dart';

class UserDetailScreen extends StatelessWidget {
  final User user;

  const UserDetailScreen({super.key, required this.user});

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => UserFormDialog(user: user),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () => _showEditDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                FadeInDown(
                  duration: const Duration(milliseconds: 600),
                  child: Container(
                    height: 250,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColor.withOpacity(0.6),
                        ],
                      ),
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -60,
                  child: Hero(
                    tag: 'avatar_${user.id}',
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(user.avatar),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 70),
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: Column(
                children: [
                   Text(
                    '${user.firstName} ${user.lastName}',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user.email,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: FadeInUp(
                delay: const Duration(milliseconds: 400),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.email_outlined, color: Theme.of(context).primaryColor),
                          title: const Text('Email'),
                          subtitle: Text(user.email),
                        ),
                        const Divider(),
                        ListTile(
                          leading: Icon(Icons.badge_outlined, color: Theme.of(context).primaryColor),
                          title: const Text('ID'),
                          subtitle: Text('#${user.id}'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
