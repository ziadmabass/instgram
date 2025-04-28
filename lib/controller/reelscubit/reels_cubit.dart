import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'reels_state.dart';

class ReelsCubit extends Cubit<ReelsState> {
  ReelsCubit() : super(ReelsInitial());

  final List<Widget> _mediaList = [];
  final List<File> _path = [];
  File? _selectedFile;
  int currentPage = 0;

  Future<void> fetchNewMedia() async {
    emit(ReelsLoading());

    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (ps.isAuth) {
      List<AssetPathEntity> album =
          await PhotoManager.getAssetPathList(type: RequestType.video);
      List<AssetEntity> media =
          await album[0].getAssetListPaged(page: currentPage, size: 60);

      for (var asset in media) {
        if (asset.type == AssetType.video) {
          final file = await asset.file;
          if (file != null) {
            _path.add(File(file.path));
            _selectedFile ??= _path[0];
          }
        }
      }

      List<Widget> temp = [];
      for (var asset in media) {
        temp.add(
          FutureBuilder(
            future: asset.thumbnailDataWithSize(const ThumbnailSize(200, 200)),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.data != null) {
                return Stack(
                  children: [
                    Positioned.fill(
                      child: Image.memory(
                        snapshot.data!,
                        fit: BoxFit.cover,
                      ),
                    ),
                    if (asset.type == AssetType.video)
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          alignment: Alignment.center,
                          width: 35,
                          height: 15,
                          child: Text(
                            '${asset.videoDuration.inMinutes}:${(asset.videoDuration.inSeconds % 60).toString().padLeft(2, '0')}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              }
              return Container();
            },
          ),
        );
      }

      _mediaList.addAll(temp);
      currentPage++;

      emit(ReelsLoaded(List.from(_mediaList), List.from(_path), _selectedFile));
    }
  }

  void selectFile(int index) {
    if (index >= 0 && index < _path.length) {
      _selectedFile = _path[index];
      emit(ReelsLoaded(List.from(_mediaList), List.from(_path), _selectedFile));
    }
  }
}
