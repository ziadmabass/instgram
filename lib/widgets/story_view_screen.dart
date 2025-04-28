// story_view_screen.dart
import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';

class StoryViewScreen extends StatelessWidget {
  final String storyUrl;

  const StoryViewScreen({Key? key, required this.storyUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final StoryController controller = StoryController();

    return Scaffold(
      body: StoryView(
        storyItems: [
          StoryItem.pageImage(
            url: storyUrl,
            controller: controller,
            duration: const Duration(seconds: 5),
          ),
        ],
        controller: controller,
        onComplete: () {
          Navigator.pop(context);
        },
        onVerticalSwipeComplete: (direction) {
          if (direction == Direction.down) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
