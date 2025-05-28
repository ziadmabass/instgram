abstract class ReelsState {}

class EditReelsInitial extends ReelsState {}

class EditReelsLoading extends ReelsState {}

class EditReelsLoaded extends ReelsState {}

class ReelsError extends ReelsState {
  final String message;
  ReelsError(this.message);
}
