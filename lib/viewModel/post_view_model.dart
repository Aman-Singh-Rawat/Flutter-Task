// ignore_for_file: avoid_print, file_names
import 'package:flutter/material.dart';
import 'package:flutter_task/data/repositories/post_repository.dart';
import 'package:flutter_task/data/local/database_helper.dart';
import 'package:flutter_task/models/post_data_model.dart';
import 'package:flutter_task/models/post_list_model.dart';
import 'package:flutter_task/models/post_model.dart';
import 'package:flutter_task/utils/app_loader_provider.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class PostViewModel with ChangeNotifier {
  final _authRepo = PostRepository();
  final _databaseHelper = DatabaseHelper();

  List<Post> _posts = [];
  List<Post> get posts => _posts;

  List<PostModel> _localPosts = [];
  List<PostModel> get localPosts => _localPosts;

  PostData? _postData;
  PostData? get postData => _postData;

  Future<void> fetchPostListing(
    BuildContext context, {
    required onSuccess,
    required Function onFailure,
  }) async {
    final apploader = Provider.of<AppLoaderProvider>(context, listen: false);
    apploader.show();

    try {
      await _loadPostsFromLocal();

      final value = await _authRepo.fetchPostListing((r) {}, onFailure);

      if (value != null) {
        _posts = (value as List).map((json) => Post.fromJson(json)).toList();

        final postModels = _posts.map((post) {
          final existingPost = _localPosts.firstWhere(
            (localPost) => localPost.id == post.id,
            orElse: () => PostModel.fromJson(post.toJson()),
          );

          if (existingPost.remainingTime == 0) {
            return existingPost.copyWith(
              remainingTime: Random().nextInt(11) + 5,
            );
          }

          return existingPost;
        }).toList();

        await _databaseHelper.insertPosts(postModels);
        _localPosts = postModels;

        notifyListeners();
        onSuccess(_posts);
      } else {
        if (_localPosts.isNotEmpty) {
          _posts = _localPosts
              .map(
                (postModel) => Post(
                  id: postModel.id,
                  userId: postModel.userId,
                  title: postModel.title,
                  body: postModel.body,
                ),
              )
              .toList();
          notifyListeners();
          onSuccess(_posts);
        } else {
          onFailure();
        }
      }
    } catch (error) {
      print("Failed Msg:- ${error.toString()}");
      if (_localPosts.isNotEmpty) {
        _posts = _localPosts
            .map(
              (postModel) => Post(
                id: postModel.id,
                userId: postModel.userId,
                title: postModel.title,
                body: postModel.body,
              ),
            )
            .toList();
        notifyListeners();
        onSuccess(_posts);
      } else {
        onFailure();
      }
    } finally {
      apploader.hide();
    }
  }

  Future<void> fetchPostData(
    BuildContext context, {
    required onSuccess,
    required Function onFailure,
    required String postId,
  }) async {
    final apploader = Provider.of<AppLoaderProvider>(context, listen: false);
    apploader.show();
    _authRepo
        .fetchPostData((r) {}, onFailure, postId)
        .then((value) async {
          if (value == null) {
            onFailure();
          } else {
            _postData = PostData.fromJson(value);
            notifyListeners();
            onSuccess(_postData!);
            apploader.hide();
          }
        })
        .onError((error, stackTrace) {
          apploader.hide();
          print("Failed Msg:- ${error.toString()}");
        });
  }

  Future<void> _loadPostsFromLocal() async {
    try {
      _localPosts = await _databaseHelper.getAllPosts();
    } catch (e) {
      print("Error loading posts from local storage: $e");
      _localPosts = [];
    }
  }

  Future<void> markPostAsRead(int postId) async {
    try {
      await _databaseHelper.markPostAsRead(postId);

      final index = _localPosts.indexWhere((post) => post.id == postId);
      if (index != -1) {
        _localPosts[index] = _localPosts[index].copyWith(isRead: true);
        notifyListeners();
      }
    } catch (e) {
      print("Error marking post as read: $e");
    }
  }

  Future<void> updateRemainingTime(int postId, int remainingTime) async {
    try {
      await _databaseHelper.updateRemainingTime(postId, remainingTime);

      final index = _localPosts.indexWhere((post) => post.id == postId);
      if (index != -1) {
        _localPosts[index] = _localPosts[index].copyWith(
          remainingTime: remainingTime,
        );
        notifyListeners();
      }
    } catch (e) {
      print("Error updating remaining time: $e");
    }
  }

  PostModel? getLocalPost(int postId) {
    try {
      return _localPosts.firstWhere((post) => post.id == postId);
    } catch (e) {
      return null;
    }
  }

  bool isPostRead(int postId) {
    final post = getLocalPost(postId);
    return post?.isRead ?? false;
  }

  int getRemainingTime(int postId) {
    final post = getLocalPost(postId);
    return post?.remainingTime ?? 0;
  }

  Future<void> printAllStoredPosts() async {
    try {
      final posts = await _databaseHelper.getAllPosts();
      print("=== STORED POSTS IN DATABASE ===");
      for (var post in posts) {
        print(
          "ID: ${post.id}, Title: ${post.title}, IsRead: ${post.isRead}, RemainingTime: ${post.remainingTime}",
        );
      }
      print("Total posts stored: ${posts.length}");
      print("================================");
    } catch (e) {
      print("Error printing stored posts: $e");
    }
  }

  Future<void> checkSpecificPost(int postId) async {
    try {
      final post = await _databaseHelper.getPost(postId);
      if (post != null) {
        print("=== POST DETAILS ===");
        print("ID: ${post.id}");
        print("Title: ${post.title}");
        print("IsRead: ${post.isRead}");
        print("RemainingTime: ${post.remainingTime}");
        print("===================");
      } else {
        print("Post with ID $postId not found in database");
      }
    } catch (e) {
      print("Error checking post: $e");
    }
  }
}
