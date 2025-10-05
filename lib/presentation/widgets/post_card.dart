import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/utils/constants/app_colors.dart';
import 'package:flutter_task/utils/constants/app_sizes.dart';
import 'package:flutter_task/utils/logger.dart';
import 'package:flutter_task/viewModel/post_view_model.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

class PostCard extends StatefulWidget {
  final String title;
  final String assetName;
  final VoidCallback onTap;
  final bool isRead;
  final int postId;

  const PostCard({
    Key? key,
    required this.title,
    required this.assetName,
    required this.onTap,
    this.isRead = false,
    required this.postId,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late int remainingTime;
  Timer? _timer;
  late PostViewModel _postViewModel;
  bool isVisible = false;

  @override
  void initState() {
    super.initState();
    _postViewModel = Provider.of<PostViewModel>(context, listen: false);

    final storedTime = _postViewModel.getRemainingTime(widget.postId);
    remainingTime = storedTime > 0 ? storedTime : Random().nextInt(11) + 5;

    Logger.printSuccess("this is success $storedTime");
    Logger.printSuccess("this is success $remainingTime");
  }

  void startTimer() {
    if (_timer != null) return;
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (remainingTime > 0) {
        setState(() => remainingTime--);
      } else {
        _timer?.cancel();
        _timer = null;
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.postId.toString()),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.0) {
          isVisible = true;
          startTimer();
        } else {
          isVisible = false;
          stopTimer();
        }
      },
      child: GestureDetector(
        onTap: () {
          stopTimer();
          widget.onTap();
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 25.h),
          margin: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: widget.isRead
                ? AppColors.whiteColor
                : AppColors.lightYellowColor,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              gapW12,
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    widget.assetName,
                    height: 28.h,
                    width: 28.w,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 4.h),
                  if (remainingTime > 0)
                    Text(
                      "$remainingTime s",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.blackColor,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
