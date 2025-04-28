import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class MediaState extends Equatable {
  const MediaState();

  @override
  List<Object?> get props => [];
}

class MediaInitial extends MediaState {}

class MediaLoading extends MediaState {}

class MediaLoaded extends MediaState {
  final List<File> mediaFiles;
  final File? selectedFile;

  const MediaLoaded(this.mediaFiles, {this.selectedFile});

  @override
  List<Object?> get props => [mediaFiles, selectedFile];
}

class MediaError extends MediaState {
  final String message;
  const MediaError(this.message);

  @override
  List<Object?> get props => [message];
}
