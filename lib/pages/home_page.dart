import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_note_page.dart';

class HomePage extends StatefulWidget {
  final String userId; // pass user uid from login/signup

  HomePage({required this.userId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Notes'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notes')
            .where('userId', isEqualTo: widget.userId)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No notes found. Click + to add."));
          }

          final notes = snapshot.data!.docs;

          return GridView.builder(
            padding: EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              final noteData = note.data() as Map<String, dynamic>;

              return Card(
                color: Theme.of(context).cardColor,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        noteData['title'] ?? 'No Title',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 5),
                      Text(
                        noteData['description'] ?? '',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Spacer(),
                      if (noteData['fileUrl'] != null)
                        Text(
                          "File attached",
                          style: TextStyle(fontSize: 12, color: Colors.blue),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddNotePage(userId: widget.userId),
            ),
          );
        },
      ),
    );
  }
}
