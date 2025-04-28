import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testfirebase/controller/reelscubit/reels_cubit.dart';
import 'package:testfirebase/controller/reelscubit/reels_state.dart';
import 'package:testfirebase/screen/reels_edite_screen.dart';


class AddReelsScreen extends StatelessWidget {
  const AddReelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReelsCubit()..fetchNewMedia(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).colorScheme.primary,
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            'newreel'.tr(),
            style:  TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          elevation: 0,
        ),
        body: SafeArea(
          child: BlocBuilder<ReelsCubit, ReelsState>(
            builder: (context, state) {
              if (state is ReelsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ReelsLoaded) {
                return GridView.builder(
                  shrinkWrap: true,
                  itemCount: state.mediaList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisExtent: 250,
                    crossAxisSpacing: 3.w,
                    mainAxisSpacing: 5.h,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        context.read<ReelsCubit>().selectFile(index);
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              ReelsEditeScreen(state.pathList[index]),
                        ));
                      },
                      child: state.mediaList[index],
                    );
                  },
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
