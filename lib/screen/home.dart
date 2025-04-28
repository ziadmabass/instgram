import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testfirebase/chat/presentation/screens/chat_list_screen.dart';
import 'package:testfirebase/widgets/post_widget.dart';
import 'package:testfirebase/widgets/story_bar.dart'; // <-- make sure you import this
import 'package:testfirebase/widgets/story_view_screen.dart'; // <-- keep this if used elsewhere

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        title: SizedBox(
          width: 105.w,
          height: 28.h,
          child: Text(
            'instagram'.tr(),
            style: TextStyle(
              fontFamily: 'Billabong',
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
        actions: [
          const Icon(
            Icons.favorite_border_outlined,
            size: 25,
          ),
          SizedBox(width: 20.w),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatListScreen()),
              );
            },
            icon: Icon(
              Icons.chat_bubble_outline_outlined,
              size: 25,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          SizedBox(width: 8.w),
        ],
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomScrollView(
          slivers: [
            // 👇👇 ADD STORIES BAR HERE
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: const StoriesBar(), // <--- add your StoriesBar widget
              ),
            ),
            // 👇 POSTS LIST
            StreamBuilder(
              stream: _firebaseFirestore
                  .collection('posts')
                  .orderBy('time', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return PostWidget(snapshot.data!.docs[index].data());
                    },
                    childCount: snapshot.data == null ? 0 : snapshot.data!.docs.length,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
