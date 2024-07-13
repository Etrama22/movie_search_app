import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class AccountSettingsScreen extends StatefulWidget {
  final String username;
  final VoidCallback onUsernameChanged;

  AccountSettingsScreen({
    required this.username,
    required this.onUsernameChanged,
  });

  @override
  _AccountSettingsScreenState createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;

  @override
  void initState() {
    super.initState();
    usernameController.text = widget.username;
  }

  Future<void> updateUsername() async {
    setState(() {
      isLoading = true;
    });

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .update({'username': usernameController.text.trim()});

      setState(() {
        isLoading = false;
      });

      widget.onUsernameChanged();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Username updated successfully!')),
      );
    }
  }

  Future<void> pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        _selectedImage = pickedFile;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<void> uploadImage() async {
    if (_selectedImage != null) {
      setState(() {
        isLoading = true;
      });

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_images')
            .child('${user.uid}.jpg');
        try {
          await storageRef.putFile(File(_selectedImage!.path));
          final photoUrl = await storageRef.getDownloadURL();

          await FirebaseFirestore.instance
              .collection('Users')
              .doc(user.uid)
              .update({'photoUrl': photoUrl});

          setState(() {
            isLoading = false;
          });

          widget.onUsernameChanged();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile image updated successfully!')),
          );
        } catch (e) {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error uploading image: $e')),
          );
        }
      }
    }
  }

  void resetPassword() {
    // Implement reset password functionality here
  }

  void deleteAccount() {
    // Implement delete account functionality here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Account Settings',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Edit Username',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          ListTile(
                            leading: Icon(Icons.person),
                            title: TextField(
                              controller: usernameController,
                              decoration: InputDecoration(
                                hintText: 'Enter new username',
                              ),
                            ),
                            trailing: ElevatedButton(
                              onPressed: updateUsername,
                              child: Text('Update'),
                            ),
                          ),
                          Divider(),
                          Text(
                            'Profile Picture',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          ListTile(
                            leading: Icon(Icons.image),
                            title: Text('Pick Profile Picture'),
                            trailing: ElevatedButton(
                              onPressed: pickImage,
                              child: Text('Pick'),
                            ),
                          ),
                          SizedBox(height: 10),
                          _selectedImage != null
                              ? CircleAvatar(
                                  radius: 60,
                                  backgroundImage:
                                      FileImage(File(_selectedImage!.path)),
                                )
                              : Container(),
                          SizedBox(height: 10),
                          ListTile(
                            trailing: ElevatedButton(
                              onPressed: uploadImage,
                              child: Text('Upload'),
                            ),
                          ),
                          Divider(),
                          Text(
                            'Account Management',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          ListTile(
                            leading: Icon(Icons.lock),
                            title: Text('Reset Password'),
                            trailing: ElevatedButton(
                              onPressed: resetPassword,
                              child: Text('Reset'),
                            ),
                          ),
                          SizedBox(height: 10),
                          ListTile(
                            leading: Icon(Icons.delete),
                            title: Text('Delete Account'),
                            trailing: ElevatedButton(
                              onPressed: deleteAccount,
                              child: Text('Delete'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
