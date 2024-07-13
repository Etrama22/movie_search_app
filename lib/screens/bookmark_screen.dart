import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'movie_detail.dart';

// Kelas StatefulWidget untuk layar bookmark
class BookmarkScreen extends StatefulWidget {
  List<dynamic> bookmarks;

  // Konstruktor dengan parameter bookmarks yang diperlukan
  BookmarkScreen({required this.bookmarks});

  @override
  _BookmarkScreenState createState() => _BookmarkScreenState();
}

// State class untuk BookmarkScreen
class _BookmarkScreenState extends State<BookmarkScreen> {
  late CollectionReference bookmarksCollection;

  @override
  void initState() {
    super.initState();
    // Mengatur referensi koleksi bookmarks dari Firestore
    bookmarksCollection = FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('bookmarks');

    // Memanggil fungsi untuk mengambil data bookmarks
    getBookmarks();
  }

  // Fungsi untuk mengambil data bookmarks dari Firestore
  void getBookmarks() async {
    try {
      QuerySnapshot querySnapshot = await bookmarksCollection.get();
      List<dynamic> bookmarks = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Menambahkan id dokumen ke data movie
        return data;
      }).toList();
      setState(() {
        widget.bookmarks = bookmarks;
      });
    } catch (e) {
      print('Error getting bookmarks: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bookmarks',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: widget.bookmarks.isEmpty
          ? Center(
              child: Text(
                'No bookmarks added.',
                style: TextStyle(fontSize: 18.0, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: widget.bookmarks.length,
              itemBuilder: (context, index) {
                final movie = widget.bookmarks[index];
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(10.0),
                    leading: movie['poster_path'] != null
                        ? Image.network(
                            'https://image.tmdb.org/t/p/w92${movie['poster_path']}',
                            fit: BoxFit.cover,
                            width: 50,
                          )
                        : Container(
                            width: 50,
                            color: Colors.grey,
                            child: Icon(
                              Icons.movie,
                              color: Colors.white,
                            ),
                          ),
                    title: Text(
                      movie['title'] ?? 'No Title',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    subtitle: Text(
                      'Release Date: ${movie['release_date'] ?? 'Unknown'}',
                      style: TextStyle(fontSize: 14.0),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete_outline),
                      onPressed: () {
                        _removeBookmark(movie);
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieDetailScreen(movie: movie),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }

  // Fungsi untuk menghapus bookmark dari Firestore
  void _removeBookmark(dynamic movie) async {
    try {
      print('Trying to remove bookmark: ${movie['id']}');
      await bookmarksCollection.doc(movie['id']).delete();
      setState(() {
        widget.bookmarks.remove(movie);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Removed from bookmarks')),
      );
    } catch (e) {
      print('Error removing bookmark: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove from bookmarks')),
      );
    }
  }
}
