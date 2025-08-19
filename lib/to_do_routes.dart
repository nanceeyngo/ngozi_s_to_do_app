import 'package:get/get.dart';
import 'package:ngozi_s_to_do_app/to_do_app/user_interface/pages/pages.dart';

class ToDoRoutes{
  static List<GetPage> getRoutes(){
    return[
      GetPage(name: '/', page: () => ToDoListPage()),
      GetPage(name: '/add_todo', page: () => AddToDoPage()),
      GetPage(name: '/edit_todo', page: () => EditToDoPage()),
      GetPage(name: '/todo_details', page: () => ToDoDetailsPage())
    ];
  }
}