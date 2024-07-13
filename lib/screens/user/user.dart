import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie_search_app/screens/bookmark_screen.dart';
import 'package:movie_search_app/screens/user/user_edit_ui.dart';

// Kelas StatefulWidget untuk layar pengguna
class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

// State untuk UserScreen
class _UserScreenState extends State<UserScreen> {
  final User? user =
      FirebaseAuth.instance.currentUser; // Pengguna saat ini dari FirebaseAuth

  // Mengambil data pengguna dari Firestore
  Future<Map<String, dynamic>?> getUserData() async {
    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user!.uid)
          .get();
      return userData.data() as Map<String, dynamic>?;
    }
    return null;
  }

  // Memperbarui data pengguna
  void refreshUserData() {
    setState(() {});
  }

  // Mengambil bookmark dari Firestore
  Future<List<dynamic>> _fetchBookmarks() async {
    List<dynamic> bookmarks = [];
    if (user != null) {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user!.uid)
          .collection('bookmarks')
          .get();
      bookmarks = snapshot.docs.map((doc) => doc.data()).toList();
    }
    return bookmarks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Screen'),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error loading user data'));
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No user data found'));
          }

          Map<String, dynamic>? userData = snapshot.data;
          String username = userData?['username'] ?? 'Username';
          String email = userData?['email'] ?? 'Email';
          String photoUrl =
              userData?['photoUrl'] ?? 'https://via.placeholder.com/150';

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Informasi pengguna
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 100,
                        backgroundImage: NetworkImage(photoUrl),
                      ),
                      SizedBox(height: 16),
                      Text(
                        username,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        email,
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // Kartu untuk pengaturan akun
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(Icons.settings),
                            title: Text('Account Settings'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AccountSettingsScreen(
                                    username: username,
                                    onUsernameChanged: refreshUserData,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Kartu untuk bookmark
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(Icons.bookmark),
                            title: Text('Bookmarks'),
                            onTap: () async {
                              List<dynamic> bookmarks = await _fetchBookmarks();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookmarkScreen(
                                    bookmarks: bookmarks,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Kartu untuk logout
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(Icons.logout),
                            title: Text('Log Out'),
                            onTap: () async {
                              await FirebaseAuth.instance.signOut();
                              Navigator.of(context)
                                  .pushReplacementNamed('/login');
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
