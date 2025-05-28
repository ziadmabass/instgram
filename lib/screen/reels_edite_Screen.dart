import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testfirebase/controller/addreelscupit/reels_cubit.dart';
import 'package:testfirebase/controller/addreelscupit/reels_state.dart';

import 'package:video_player/video_player.dart';


class ReelsEditeScreen extends StatelessWidget {
  final File videoFile;
  const ReelsEditeScreen(this.videoFile, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReelsCubit(),
      child: ReelsEditeScreenBody(videoFile),
    );
  }
}

class ReelsEditeScreenBody extends StatefulWidget {
  final File videoFile;
  const ReelsEditeScreenBody(this.videoFile, {super.key});

  @override
  State<ReelsEditeScreenBody> createState() => _ReelsEditeScreenBodyState();
}

class _ReelsEditeScreenBodyState extends State<ReelsEditeScreenBody> {
  final caption = TextEditingController();
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((_) {
        setState(() {});
        controller.setLooping(true);
        controller.setVolume(1.0);
        controller.play();
      });
  }

  @override
  void dispose() {
    controller.dispose();
    caption.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReelsCubit, ReelsState>(
      listener: (context, state) {
        if (state is EditReelsLoaded) {
          Navigator.pop(context);
        } else if (state is ReelsError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
          ));
        }
      },
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.black),
            centerTitle: false,
            title: Text(
              'newreel'.tr(),
              style: const TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          body: SafeArea(
            child: state is EditReelsLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Column(
                      children: [
                        SizedBox(height: 30.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40.w),
                          child: SizedBox(
                            width: 270.w,
                            height: 420.h,
                            child: controller.value.isInitialized
                                ? AspectRatio(
                                    aspectRatio: controller.value.aspectRatio,
                                    child: VideoPlayer(controller),
                                  )
                                : const CircularProgressIndicator(),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        SizedBox(
                          height: 60,
                          width: 280.w,
                          child: TextField(
                            controller: caption,
                            maxLines: 10,
                            decoration: InputDecoration(
                              hintText: 'writecaption'.tr(),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const Divider(),
                        SizedBox(height: 20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              height: 45.h,
                              width: 150.w,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Text(
                                'savedraft'.tr(),
                                style: TextStyle(fontSize: 16.sp),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                context.read<ReelsCubit>().uploadReel(
                                      videoFile: widget.videoFile,
                                      caption: caption.text,
                                    );
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 45.h,
                                width: 150.w,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Text(
                                  'share'.tr(),
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}
