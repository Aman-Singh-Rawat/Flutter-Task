import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_task/utils/constants/app_assets.dart';
import 'package:flutter_task/utils/constants/app_colors.dart';
import 'package:flutter_task/utils/constants/app_sizes.dart';
import 'package:flutter_task/utils/constants/app_strings.dart';
import 'package:flutter_task/presentation/widgets/customToast.dart';
import 'package:flutter_task/routes/routes.dart';
import 'package:flutter_task/viewModel/post_view_model.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    fetchPostListing();
  }

  fetchPostListing() async {
    bool isConnected = await checkConnectivity();
    if (!isConnected) {
      Toasts.getErrorToast(text: "No internet connection is available.");
      return;
    }
    final postViewModel = Provider.of<PostViewModel>(context, listen: false);
    postViewModel.fetchPostListing(
      context,
      onSuccess: (response) async {
        Get.offAllNamed(Routes.postListScreen);
      },
      onFailure: (error) async {
        print("Error: $error");
      },
    );
  }

  Future<bool> checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            AppAssets.splash,
            fit: BoxFit.cover,
            width: 110.w,
            height: 110.h,
          ),
          gapH32,
          Text(
            AppStrings.flutterTask,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.blueColor,
              fontSize: 38.sp,
            ),
          ),
          gapH48,
          SpinKitCircle(color: AppColors.blueColor, size: 60.w),
        ],
      ),
    );
  }
}
