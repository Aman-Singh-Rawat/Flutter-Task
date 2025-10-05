import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/utils/constants/app_assets.dart';
import 'package:flutter_task/utils/constants/app_colors.dart';
import 'package:flutter_task/utils/constants/app_strings.dart';
import 'package:flutter_task/presentation/screens/post_details_screen.dart';
import 'package:flutter_task/presentation/widgets/custom_app_bar.dart';
import 'package:flutter_task/presentation/widgets/post_card.dart';
import 'package:flutter_task/viewModel/post_view_model.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class PostListingScreen extends StatefulWidget {
  const PostListingScreen({super.key});

  @override
  State<PostListingScreen> createState() => _PostListingScreenState();
}

class _PostListingScreenState extends State<PostListingScreen> {
  PostViewModel? postListingProvider;

  @override
  Widget build(BuildContext context) {
    postListingProvider = Provider.of<PostViewModel>(context, listen: true);

    final posts = postListingProvider?.posts ?? [];

    return Scaffold(
      backgroundColor: AppColors.lightGreyColor,
      appBar: CustomAppBar(title: AppStrings.postListing),
      body: posts.isEmpty
          ? const Center(child: Text("No posts available"))
          : ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 2.h,
                  ),
                  child: PostCard(
                    title: post.title ?? '',
                    assetName: AppAssets.clock,
                    postId: post.id ?? 0,
                    isRead: postListingProvider?.isPostRead(post.id ?? 0) ?? false,
                    onTap: () async {
                      if (post.id != null) {
                        await postListingProvider?.markPostAsRead(post.id!);
                      }
                      await Get.to(
                        () => PostDetailScreen(postId: posts[index].id ?? 0),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
