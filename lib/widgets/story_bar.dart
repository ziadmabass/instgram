// stories_bar.dart
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:story_view/story_view.dart';
import 'package:uuid/uuid.dart';

import 'story_view_screen.dart'; // (we'll create this next)

class StoriesBar extends StatefulWidget {
  const StoriesBar({Key? key}) : super(key: key);

  @override
  State<StoriesBar> createState() => _StoriesBarState();
}

class _StoriesBarState extends State<StoriesBar> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> uploadStory() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? file = await picker.pickImage(source: ImageSource.gallery);

      if (file != null) {
        Uint8List fileBytes = await file.readAsBytes();
        String uid = _auth.currentUser!.uid;
        String storyId = const Uuid().v1();

        Reference ref = _storage.ref().child('stories').child(uid).child(storyId);
        UploadTask uploadTask = ref.putData(fileBytes);
        TaskSnapshot snap = await uploadTask;
        String downloadUrl = await snap.ref.getDownloadURL();

        await _firestore.collection('stories').doc(storyId).set({
          'uid': uid,
          'storyUrl': downloadUrl,
          'timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Story uploaded successfully!')),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload story: $e')),
      );
    }
  }

  Stream<QuerySnapshot> getStories() {
    return _firestore
        .collection('stories')
        .where('timestamp', isGreaterThan: Timestamp.now().toDate().subtract(const Duration(hours: 24)))
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: StreamBuilder<QuerySnapshot>(
        stream: getStories(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final stories = snapshot.data!.docs;

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: stories.length + 1, // +1 for "Add Story" button
            itemBuilder: (context, index) {
              if (index == 0) {
                return GestureDetector(
                  onTap: uploadStory,
                  child: Container(
                    width: 80,
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.green, width: 3),
                      color: Colors.grey[300],
                    ),
                    child: const Icon(Icons.add, size: 40),
                  ),
                );
              }

              final storyData = stories[index - 1];
              final storyUrl = storyData['storyUrl'];

              return GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return StoryViewScreen(storyUrl: storyUrl);
                  }));
                },
                child: Container(
                  width: 80,
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.blueAccent, width: 3),
                    image: DecorationImage(
                      image: NetworkImage(storyUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
