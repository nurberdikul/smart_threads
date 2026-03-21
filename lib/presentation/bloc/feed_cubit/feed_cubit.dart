import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_threads/domain/repositories/post_repository.dart';
import 'package:smart_threads/presentation/bloc/feed_cubit/feed_state.dart';

class FeedCubit extends Cubit<FeedState> {
  final PostRepository _repository;

  FeedCubit(this._repository) : super(const FeedState());

  Future<void> loadFeed() async {
    emit(state.copyWith(status: FeedStatus.loading, errorMessage: null));

    try {
      final posts = await _repository.getFeed();
      emit(state.copyWith(status: FeedStatus.success, posts: posts));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Ошибка', 
      status: FeedStatus.failure));
    }
  }
}
