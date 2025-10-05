// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/routes/app_routes.dart';
import 'package:flutter_task/routes/routes.dart';
import 'package:flutter_task/utils/app_loader_provider.dart';
import 'package:flutter_task/viewModel/post_view_model.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(440, 956),
      minTextAdapt: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AppLoaderProvider()),
            ChangeNotifierProvider(create: (_) => PostViewModel()),
          ],
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: const TextScaler.linear(1.0)),
                child: child!,
              );
            },
            getPages: AppRoutes().getRoutes(),
            initialRoute: Routes.initial,
          ),
        );
      },
    );
  }
}
