import 'package:hive_flutter/hive_flutter.dart';
import 'package:get/get.dart';
import 'package:ngozi_s_to_do_app/to_do_app/controllers/to_do_controller.dart';
import 'package:ngozi_s_to_do_app/to_do_app/repositories/to_do_repository.dart';
import 'package:ngozi_s_to_do_app/to_do_app/services/to_do_notification_service.dart';

class TodDoBindings extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
  }

  // Future<void> _initHive() async{
  //   await Hive.initFlutter();
  //   await Hive.openBox('todos');
  // }

  void _injectRepository(){
    Get.lazyPut<TodoRepository>(
        () => TodoRepoImpl(box: Hive.box('todos')),
        fenix: true //re-create if removed from memory
    );
  }

  Future<void> _injectNotificationService() async{
    final notificationService = TodoNotificationServiceImpl();
    await notificationService.init();
    Get.put<TodoNotificationService>(notificationService, permanent: true);
  }

  void _injectController(){
    Get.lazyPut<TodoController>(
        () => TodoControllerImpl(
            repo: Get.find<TodoRepository>(),
            //notificationService: TodoNotificationServiceImpl()
            notificationService: Get.find<TodoNotificationService>()
        ),
        fenix: true
    );
  }

}