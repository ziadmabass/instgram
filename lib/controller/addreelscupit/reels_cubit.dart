import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testfirebase/data/firebase_service/firestor.dart';
import 'package:testfirebase/data/firebase_service/storage.dart';
import 'reels_state.dart';

class ReelsCubit extends Cubit<ReelsState> {
  ReelsCubit() : super(EditReelsInitial());

  Future<void> uploadReel({
    required File videoFile,
    required String caption,
  }) async {
    try {
      emit(EditReelsLoading());
      final reelsUrl = await StorageMethod().uploadImageToStorage('Reels', videoFile);
      await Firebase_Firestor().CreatReels(video: reelsUrl, caption: caption);
      emit(EditReelsLoaded());
    } catch (e) {
      emit(ReelsError(e.toString()));
    }
  }
}
