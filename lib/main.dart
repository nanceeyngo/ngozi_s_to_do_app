import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:ngozi_s_to_do_app/to_do_app.dart';
import 'package:ngozi_s_to_do_app/to_do_app/services/to_do_notification_service.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('todos');

  final notificationService = TodoNotificationServiceImpl();
  await notificationService.init();
  
  Get.put<TodoNotificationService>(notificationService, permanent: true);

  runApp(const ToDoApp());
}
