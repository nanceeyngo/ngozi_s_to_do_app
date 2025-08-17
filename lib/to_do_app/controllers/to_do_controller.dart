import 'package:get/get.dart';
import 'package:ngozi_s_to_do_app/to_do_app/models/to_do.dart';
import 'package:ngozi_s_to_do_app/to_do_app/repositories/to_do_repository.dart';
import 'package:ngozi_s_to_do_app/to_do_app/services/to_do_notification_service.dart';


abstract interface class TodoController{
  RxList<Todo> get todos;
  void loadAll();
  Todo? findbyId(String id);
  List<Todo> topLevelTodos();
  List<Todo> childrenOf(String parentId);
  Future<void> reschedule(Todo todo);
  Future<void> addOrUpdate(Todo todo);
  Future<void> deleteTodo(Todo todo);
  Future<void> toggleDone(Todo todo);
  bool canNest(Todo parent, Todo child);
  Future<bool> nestUnder(Todo parent, Todo child);



}

class TodoControllerImpl extends GetxController implements TodoController{

  final TodoRepository _repo;
  final TodoNotificationService _notificationService;

  TodoControllerImpl({
    required TodoRepository repo,
    required TodoNotificationService notificationService
}): _repo = repo,
    _notificationService = notificationService;

  final RxList<Todo> _todos = <Todo>[].obs; //flat list of all todos

  @override
  RxList<Todo> get todos => _todos;

  @override
  void loadAll() {
    todos.value = _repo.getAll();
  }

  @override
  Todo? findbyId(String id) => todos.firstWhereOrNull((test)=> test.id == id);

  @override
  List<Todo> topLevelTodos() => todos.where((test)=> test.parentId == null).toList();

  @override
  List<Todo> childrenOf(String parentId) => todos.where((test)=> test.parentId == parentId).toList();

  @override
  Future<void> reschedule(Todo todo) async {
    //cancel then schedule afresh --to avoid duplicating scheduling
    await _notificationService.cancelReminderForTodo(todo);
    if(!todo.done) await _notificationService.scheduleReminderForTodo(todo);
  }

  @override
  Future<void> addOrUpdate(Todo todo) async {
    await _repo.saveTodo(todo);
    await reschedule(todo);
    loadAll();
  }

  @override
  Future<void> deleteTodo(Todo todo) async{
    //recursively delete children
    for(final childId in todo.subTodoIds.toList()){
      final child = findbyId(childId);
      if(child != null) await deleteTodo(child);
    }
    await _notificationService.cancelReminderForTodo(todo);
    await _repo.deleteTodo(todo.id);
    loadAll();
  }

  @override
  Future<void> toggleDone(Todo todo) async{
    todo.done = !todo.done;
    final index = todos.indexWhere((test)=> test.id == todo.id);
    if(index >= 0) todos[index] = todo;

    await _repo.saveTodo(todo);

    if(todo.done){
      await _notificationService.cancelReminderForTodo(todo);
    }else{
      await reschedule(todo);
    }
  }

  @override
  bool canNest(Todo parent, Todo child) {

  }

}