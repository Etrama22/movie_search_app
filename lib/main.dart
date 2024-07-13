import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:movie_search_app/firebase_options.dart';
import 'auth/screens/login_page.dart';
import 'auth/screens/reg_page.dart';
import 'screens/home_screen.dart';
import 'screens/hot_movie.dart';
import 'screens/user/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Search App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => MainScreen(),
        // Keep routes to individual screens if you need to navigate to them directly.
        '/home_screen': (context) => HomeScreen(),
        '/hot_movie': (context) => HotMovieScreen(),
        '/user': (context) => UserScreen(),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(),
          HotMovieScreen(),
          UserScreen(),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        items: [
          Icon(
            Icons.home,
            size: 30,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
          Icon(
            Icons.whatshot,
            size: 30,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
          Icon(
            Icons.person,
            size: 30,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ],
        index: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.transparent,
        color: Color.fromARGB(255, 0, 0, 0),
        buttonBackgroundColor: Color.fromARGB(255, 0, 0, 0),
        height: 60,
        animationDuration: Duration(milliseconds: 200),
      ),
      extendBody: true,
    );
  }
}
