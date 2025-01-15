import 'package:flutter/material.dart';
import 'package:runmate/repositories/challenge_repository.dart';

import '../models/user.dart';

class UserFormScreen extends StatefulWidget {
  const UserFormScreen({Key? key}) : super(key: key);

  @override
  _UserFormScreenState createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();

// Text controllers to manage the input values
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _avatarUrlController = TextEditingController();
  final TextEditingController _totalDistanceController = TextEditingController();
  final TextEditingController _totalTimeController = TextEditingController();

// To store the created user
  User? _createdUser;

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final String name = _nameController.text;
      final String email = _emailController.text;
      final String avatarUrl = _avatarUrlController.text;
      final double totalDistance = double.tryParse(_totalDistanceController.text) ?? 0.0;
      final int totalTime = int.tryParse(_totalTimeController.text) ?? 0;

      final newUser = User(
        name: name,
        email: email,
        avatarUrl: avatarUrl,
        totalDistance: totalDistance,
        totalTime: totalTime,
      );

      UserRepository().createUser(newUser);

      setState(() {
        _createdUser = newUser;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Test User Model")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
// Name TextField
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
// Email TextField
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter an email';
                      }
                      return null;
                    },
                  ),
// Avatar URL TextField
                  TextFormField(
                    controller: _avatarUrlController,
                    decoration: InputDecoration(labelText: 'Avatar URL'),
                  ),
// Total Distance TextField
                  TextFormField(
                    controller: _totalDistanceController,
                    decoration: InputDecoration(labelText: 'Total Distance'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter total distance';
                      }
                      return null;
                    },
                  ),
// Total Time TextField
                  TextFormField(
                    controller: _totalTimeController,
                    decoration: InputDecoration(labelText: 'Total Time'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter total time';
                      }
                      return null;
                    },
                  ),
// Submit Button
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Submit'),
                  ),
                ],
              ),
            ),
            if (_createdUser != null) ...[
// Display the created user
              SizedBox(height: 20),
              Text('User Created:'),
              Text('Name: ${_createdUser?.name}'),
              Text('Email: ${_createdUser?.email}'),
              Text('Avatar URL: ${_createdUser?.avatarUrl}'),
              Text('Total Distance: ${_createdUser?.totalDistance}'),
              Text('Total Time: ${_createdUser?.totalTime}'),
              Text('Created At: ${_createdUser?.createdAt}'),
            ]
          ],
        ),
      ),
    );
  }
}