import 'package:flutter/material.dart';

class SavedPosts extends StatelessWidget {
  final List<String> likedPosts;

  const SavedPosts({super.key, required this.likedPosts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liked Posts'),
      ),
      body: likedPosts.isEmpty
          ? const Center(child: Text('No liked posts yet.'))
          : ListView.builder(
              itemCount: likedPosts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(likedPosts[index]),
                );
              },
            ),
    );
  }
}