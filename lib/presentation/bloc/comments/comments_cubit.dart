import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_threads/domain/entities/comment.dart';
import 'package:smart_threads/domain/repositories/comment_repository.dart';
import 'package:smart_threads/presentation/bloc/comments/comments_state.dart';

class CommentsCubit extends Cubit<CommentsState> {
  final CommentRepository _repository;
  final String _postId;

  CommentsCubit(this._repository, this._postId) : super(const CommentsState());

  Future<void> loadComments() async {
    emit(state.copyWith(status: CommentsStatus.loading));

    try {
      final commentsList = await _repository.getComments(_postId);
      
      emit(state.copyWith(
        status: CommentsStatus.success,
        comment: commentsList,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CommentsStatus.failure,
        errorMessage: 'Ошибка при загрузке комментариев: $e',
      ));
    }
  }

  Future<void> addComment() async {
    if (!state.canSubmit) return;

    emit(state.copyWith(status: CommentsStatus.loading));

    try {
      final newComment = Comment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        postId: _postId,
        content: state.inputText.trim(),
        authorId: '1',
        createdAt: DateTime.now().toIso8601String(),
      );

      await _repository.addComment(newComment);

      emit(state.copyWith(inputText: ''));

      await loadComments();

    } catch (e) {
      emit(state.copyWith(
        status: CommentsStatus.failure,
        errorMessage: 'Ошибка при добавлении комментария: $e',
      ));
    }
  }

  void inputChanged(String value) {
    emit(state.copyWith(inputText: value));
  }
}