import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testfirebase/data/firebase_service/firestor.dart';
import 'package:testfirebase/util/image_cached.dart';
import 'package:testfirebase/widgets/comment.dart';
import 'package:testfirebase/widgets/like_animation.dart';

class PostWidget extends StatefulWidget {
  final snapshot;
  const PostWidget(this.snapshot, {super.key});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  final Firebase_Firestor _firestoreService =
      Firebase_Firestor(); // Instantiate FirestoreService

  late List savedUsers;

  Future<void> savePost() async {
    try {
      final uid = _auth.currentUser!.uid;

      await _firestoreService.savePost(
        postId: widget.snapshot['postId'],
        uid: uid,
      );

      setState(() {
        if (savedUsers.contains(uid)) {
          savedUsers.remove(uid); 
        } else {
          savedUsers.add(uid);
        }
      });
    } catch (e) {
      print('Error saving post: $e');
    }
  }

  bool isAnimating = false;
  String user = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    user = _auth.currentUser!.uid;
    savedUsers = widget.snapshot['saved'] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 375.w,
          height: 54.h,
          color: Theme.of(context).colorScheme.primary,
          child: Center(
            child: ListTile(
              leading: ClipOval(
                child: SizedBox(
                  width: 35.w,
                  height: 35.h,
                  child: CachedImage(widget.snapshot['profileImage']),
                ),
              ),
              title: Text(
                widget.snapshot['username'],
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              subtitle: Text(
                widget.snapshot['location'],
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              trailing: const Icon(Icons.more_horiz),
            ),
          ),
        ),
        SizedBox(height: 10.h),
        GestureDetector(
          onDoubleTap: () {
            Firebase_Firestor().like(
                like: widget.snapshot['like'],
                type: 'posts',
                uid: user,
                postId: widget.snapshot['postId']);
            setState(() {
              isAnimating = true;
            });
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 375.w,
                height: 375.h,
                child: CachedImage(
                  widget.snapshot['postImage'],
                ),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isAnimating ? 1 : 0,
                child: LikeAnimation(
                  isAnimating: isAnimating,
                  duration: const Duration(milliseconds: 400),
                  iconlike: false,
                  End: () {
                    setState(() {
                      isAnimating = false;
                    });
                  },
                  child: Icon(
                    Icons.favorite,
                    size: 100.w,
                    color: Colors.red,
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          width: 375.w,
          color: Theme.of(context).colorScheme.primary,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 14.h),
              Row(
                children: [
                  SizedBox(width: 11.w),
                  LikeAnimation(
                    isAnimating: widget.snapshot['like'].contains(user),
                    child: IconButton(
                      onPressed: () {
                        Firebase_Firestor().like(
                            like: widget.snapshot['like'],
                            type: 'posts',
                            uid: user,
                            postId: widget.snapshot['postId']);
                      },
                      icon: Icon(
                        widget.snapshot['like'].contains(user)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: widget.snapshot['like'].contains(user)
                            ? Colors.red
                            : Theme.of(context).colorScheme.secondary,
                        size: 24.w,
                      ),
                    ),
                  ),
                  SizedBox(width: 15.w),
                  GestureDetector(
                    onTap: () {
                      showBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) {
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            child: DraggableScrollableSheet(
                              maxChildSize: 0.6,
                              initialChildSize: 0.6,
                              minChildSize: 0.2,
                              builder: (context, scrollController) {
                                return Comment(
                                    'posts', widget.snapshot['postId']);
                              },
                            ),
                          );
                        },
                      );
                    },
                    child: Icon(
                      Icons.mode_comment_outlined,
                      size: 25.w,
                    ),
                  ),
                  SizedBox(width: 17.w),
                  Icon(
                    Icons.send_outlined,
                    size: 25.w,
                  ),
                  const Spacer(),
                  Padding(
                    padding: EdgeInsets.only(right: 15.w),
                    child: InkWell(
                      onTap:
                          savePost, 
                      child: Icon(
                        savedUsers.contains(user)
                            ? Icons.bookmark
                            : Icons.bookmark_border_outlined,
                        size: 28,
                        color: savedUsers.contains(user)
                            ? Colors.green
                            : Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 30.w,
                  bottom: 8.h,
                  right: 30.w,
                ),
                child: Text(
                  widget.snapshot['like'].length.toString(),
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.snapshot['username'] +
                            ' :  ' +
                            widget.snapshot['caption'],
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.w, top: 20.h, bottom: 8.h),
                child: Text(
                  formatDate(widget.snapshot['time'].toDate(),
                      [yyyy, '-', mm, '-', dd]),
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
