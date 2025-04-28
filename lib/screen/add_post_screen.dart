import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testfirebase/controller/mediacubit/media_cupit.dart';
import 'package:testfirebase/controller/mediacubit/media_state.dart';
import 'package:testfirebase/screen/addpost_text.dart';


class AddPostScreen extends StatelessWidget {
  const AddPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MediaCubit()..loadMedia(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          elevation: 0,
          title: Text(
            'newpost'.tr(),
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
          centerTitle: false,
          actions: [
            BlocBuilder<MediaCubit, MediaState>(
              builder: (context, state) {
                if (state is MediaLoaded && state.selectedFile != null) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AddPostTextScreen(state.selectedFile!),
                      ));
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Text(
                        'next'.tr(),
                        style: TextStyle(fontSize: 15.sp, color: Colors.blue),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        body: SafeArea(
          child: BlocBuilder<MediaCubit, MediaState>(
            builder: (context, state) {
              if (state is MediaLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is MediaError) {
                return Center(child: Text(state.message));
              } else if (state is MediaLoaded) {
                return Column(
                  children: [
                    SizedBox(
                      height: 375.h,
                      child: state.selectedFile != null
                          ? Image.file(state.selectedFile!, fit: BoxFit.cover)
                          : const Center(child: Text("No Image Selected")),
                    ),
                    Container(
                      width: double.infinity,
                      height: 40.h,
                      color: Theme.of(context).colorScheme.primary,
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Text(
                        'recent'.tr(),
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                        shrinkWrap: true,
                        itemCount: state.mediaFiles.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 1,
                          crossAxisSpacing: 2,
                        ),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              context.read<MediaCubit>().selectFile(state.mediaFiles[index]);
                            },
                            child: Image.file(state.mediaFiles[index], fit: BoxFit.cover),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }
              return const Center(child: Text("No media found"));
            },
          ),
        ),
      ),
    );
  }
}
