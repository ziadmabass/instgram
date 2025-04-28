import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';
import 'media_state.dart';

class MediaCubit extends Cubit<MediaState> {
  MediaCubit() : super(MediaInitial());

  Future<void> loadMedia() async {
    emit(MediaLoading());

    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (!ps.isAuth) {
      emit(const MediaError("Permission denied"));
      return;
    }

    try {
      List<AssetPathEntity> album =
          await PhotoManager.getAssetPathList(type: RequestType.image);
      List<AssetEntity> media =
          await album[0].getAssetListPaged(page: 0, size: 60);

      List<File> files = [];
      for (var asset in media) {
        final file = await asset.file;
        if (file != null) {
          files.add(File(file.path));
        }
      }

      emit(MediaLoaded(files, selectedFile: files.isNotEmpty ? files[0] : null));
    } catch (e) {
      emit(MediaError(e.toString()));
    }
  }

  void selectFile(File file) {
    if (state is MediaLoaded) {
      emit(MediaLoaded((state as MediaLoaded).mediaFiles, selectedFile: file));
    }
  }
}
