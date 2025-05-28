import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testfirebase/widgets/post_widget.dart'; 

class SavedPostsScreen extends StatelessWidget {
  const SavedPostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text("saved_posts".tr()),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .where('saved', arrayContains: userId) 
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final posts = snapshot.data!.docs;
          
          if (posts.isEmpty) {
            return Center(child: Text("nosaved".tr()));
          }

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return PostWidget(posts[index].data());
            },
          );
        },
      ),
    );
  }
}
