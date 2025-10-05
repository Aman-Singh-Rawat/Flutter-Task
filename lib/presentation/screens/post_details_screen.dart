// ignore_for_file: must_be_immutable, use_build_context_synchronously, avoid_print, unrelated_type_equality_checks

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/presentation/widgets/app_loader.dart';
import 'package:flutter_task/utils/app_loader_provider.dart';
import 'package:flutter_task/utils/constants/app_colors.dart';
import 'package:flutter_task/utils/constants/app_sizes.dart';
import 'package:flutter_task/utils/constants/app_strings.dart';
import 'package:flutter_task/presentation/widgets/customToast.dart';
import 'package:flutter_task/presentation/widgets/custom_app_bar.dart';
import 'package:flutter_task/viewModel/post_view_model.dart';
import 'package:provider/provider.dart';

class PostDetailScreen extends StatefulWidget {
  int postId;
  PostDetailScreen({super.key, required this.postId});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  PostViewModel? postDetailProvider;

  @override
  void initState() {
    super.initState();
    fetchPostData();
  }

  fetchPostData() async {
    bool isConnected = await checkConnectivity();
    if (!isConnected) {
      Toasts.getErrorToast(text: "No internet connection is available.");
      return;
    }
    final postViewModel = Provider.of<PostViewModel>(context, listen: false);
    postViewModel.fetchPostData(
      context,
      onSuccess: (response) async {},
      onFailure: (error) async {
        print("Error: $error");
      },
      postId: widget.postId.toString(),
    );
  }

  Future<bool> checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  @override
  Widget build(BuildContext context) {
    final apploader = Provider.of<AppLoaderProvider>(context);
    postDetailProvider = Provider.of<PostViewModel>(context, listen: true);

    return AppLoader(
      showLoader: apploader.showLoader,
      child: Scaffold(
        backgroundColor: AppColors.lightGreyColor,
        appBar: CustomAppBar(
          title: AppStrings.postDetail,
          showBackButton: true,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: SingleChildScrollView(
            child: Column(
              children: [
                gapH20,
                Text(
                  postDetailProvider?.postData?.title ?? '',
                  style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: 14.sp,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                gapH32,
                Text(
                  postDetailProvider?.postData?.body ?? '',
                  style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
