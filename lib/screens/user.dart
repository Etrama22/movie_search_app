// user_screen.dart
import 'package:flutter/material.dart';

class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // User Information
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Username: John Doe',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Email: johndoe@example.com',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),

            // Settings
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.notifications),
                      title: Text('Notifications'),
                      trailing: Switch(
                        value: true,
                        onChanged: (value) {},
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.wallpaper),
                      title: Text('Dark Mode'),
                      trailing: Switch(
                        value: false,
                        onChanged: (value) {},
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.logout),
                      title: Text('Log Out'),
                      onTap: () {
                        // Log out logic here
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
  }
}
