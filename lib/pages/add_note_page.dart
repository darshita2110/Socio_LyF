import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddNotePage extends StatefulWidget {
  final String userId;
  AddNotePage({required this.userId});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  PlatformFile? selectedFile;

  Future<void> pickFile() async {
    // Request storage permission
    if (await Permission.storage.request().isGranted) {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        setState(() {
          selectedFile = result.files.first;
        });
      }
    } else {
      // Handle permission denied
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Storage permission denied")));
    }
  }

  Future<void> uploadNote() async {
    String? fileUrl;

    if (selectedFile != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('notes/${widget.userId}/${selectedFile!.name}');
      await storageRef.putData(selectedFile!.bytes!);
      fileUrl = await storageRef.getDownloadURL();
    }

    await FirebaseFirestore.instance.collection('notes').add({
      'title': titleController.text,
      'description': descController.text,
      'fileUrl': fileUrl,
      'userId': widget.userId,
      'timestamp': FieldValue.serverTimestamp(),
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Note")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: "Title"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: descController,
              decoration: InputDecoration(labelText: "Description"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: pickFile,
              child: Text(selectedFile == null ? "Pick File" : selectedFile!.name),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: uploadNote,
              child: Text("Upload Note"),
            ),
          ],
        ),
      ),
    );
  }
}
