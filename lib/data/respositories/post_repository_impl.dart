import 'package:smart_threads/data/datasourses/local_post_datasource.dart';
import 'package:smart_threads/data/models/post_model.dart';
import 'package:smart_threads/domain/entities/post.dart';
import 'package:smart_threads/domain/repositories/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  final LocalPostDatasource _local;

  PostRepositoryImpl(this._local);

  @override
  Future<void> createPost(Post post) async{
    final model = PostModel.fromEntity(post);
    await _local.savePost(model);
  }

  @override
  Future<List<Post>> getFeed() async {
    final models = await _local.getPosts();
    return models.map((e) => e.toEntity()).toList();
  }
}
