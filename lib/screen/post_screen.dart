import 'package:flutter/material.dart';
import 'package:testfirebase/widgets/post_widget.dart';
class PostScreen extends StatelessWidget {
  final snapshot;
  const PostScreen(this.snapshot, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(child: PostWidget(snapshot)),
    );
  }
}
