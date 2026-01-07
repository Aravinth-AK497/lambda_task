import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user.dart';
import '../bloc/user_bloc.dart';
import '../bloc/user_event.dart';

class UserFormScreen extends StatefulWidget {
  final User? user; // If null, it's create mode. Else, update mode.

  const UserFormScreen({super.key, this.user});

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _jobController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user?.firstName ?? '');
    // ReqRes User entity doesn't have job, but API requires it for Create/Update.
    // We'll simulate it or just leave empty if creating, or use 'Developer' as default
    _jobController = TextEditingController(text: 'Developer'); 
  }

  @override
  void dispose() {
    _nameController.dispose();
    _jobController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (widget.user == null) {
        context.read<UserBloc>().add(
          CreateUserEvent(
            name: _nameController.text,
            job: _jobController.text,
          ),
        );
      } else {
        context.read<UserBloc>().add(
          UpdateUserEvent(
            id: widget.user!.id,
            name: _nameController.text,
            job: _jobController.text,
          ),
        );
      }
      Navigator.pop(context); // Close the form after submission (Optimistic)
      // Note: Ideally wait for success, but BLoC handles state asynchronously.
      // The ListScreen listener will show SnackBar.
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.user != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit User' : 'Create User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _jobController,
                decoration: const InputDecoration(labelText: 'Job'),
                 validator: (value) => value!.isEmpty ? 'Please enter a job' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text(isEditing ? 'Update' : 'Create'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
