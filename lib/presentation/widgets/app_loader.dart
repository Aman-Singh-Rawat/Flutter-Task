// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppLoader extends StatefulWidget {
  final bool showLoader;
  final Widget child;
  const AppLoader({super.key, required this.showLoader, required this.child});

  @override
  State<AppLoader> createState() => _AppLoaderState();
}

class _AppLoaderState extends State<AppLoader> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Visibility(visible: widget.showLoader, child: loader()),
      ],
    );
  }

  Widget loader() {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withOpacity(0.2),
          ),
          Center(
            child: CupertinoActivityIndicator(
              radius: 20.r,
              color: const Color.fromARGB(255, 172, 20, 20),
            ),
          ),
        ],
      ),
    );
  }
}
