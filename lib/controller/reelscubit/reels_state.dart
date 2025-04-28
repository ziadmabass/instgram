import 'dart:io';
import 'package:flutter/material.dart';

abstract class ReelsState {}

class ReelsInitial extends ReelsState {}

class ReelsLoading extends ReelsState {}

class ReelsLoaded extends ReelsState {
  final List<Widget> mediaList;
  final List<File> pathList;
  final File? selectedFile;

  ReelsLoaded(this.mediaList, this.pathList, this.selectedFile);
}
