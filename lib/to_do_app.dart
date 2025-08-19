import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ngozi_s_to_do_app/bindings.dart';
import 'package:ngozi_s_to_do_app/to_do_routes.dart';

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: ToDoRoutes.getRoutes(),
      initialRoute: '/',
      initialBinding: TodDoBindings(),
    );
  }
}
