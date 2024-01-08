import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_list_amit/modules/todolist_screen/cubit/state.dart';

import '../../../shared/network/local/cache_helper.dart';
import '../archive.dart';
import '../done.dart';
import '../tasks.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);
  List<Map> tasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];
  final List<Widget> screens = [
    Tasks(),
    Done(),
    Archive(),
  ];
  final List<String> text = ['Tasks', 'Done', 'Archive'];

  late Database database;
  bool floatClick = false;
  IconData icon = Icons.edit;
  int currentIndex = 0;

  bool isDark = false;

  void changeAppMode({bool? forShared}) {
    if (forShared != null) {
      isDark = forShared;
    } else {
      isDark = !isDark;
      CashHelper.putData(key: 'isDark', value: isDark)
          .then((value) => emit(AppChangeMode()));
    }
  }

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  void createDatabase() async => database = await openDatabase('todo.db',
          version: 1,
          onCreate: (database, version) => database
              .execute(
                  'CREATE TABLE tasks(id INTEGER PRIMARY KEY ,title TEXT,date TEXT,time TEXT,status TEXT)')
              .then((value) => print('table created'))
              .catchError((error) => print('${error.toString()}')),
          onOpen: (database) {
            getDataFromDatabase(database);
            print('Database opened');
          }).then((value) {
        emit(AppCreateDataBaseState());
        return database = value;
      });

  Future insertDatabase({
    required String title,
    required String date,
    required String time,
  }) async =>
      await database.transaction(
        (txn) => txn
            .rawInsert(
                'INSERT INTO tasks(title,date,time,status) VALUES("$title","$date","$time","NEW")')
            .then((value) {
          emit(AppInsertDataBaseState());
          print('$value Inserted Completed');
          getDataFromDatabase(database);
        }).catchError((error) => print('${error.toString()}')),
      );

  void getDataFromDatabase(database) {
    tasks = [];
    doneTasks = [];
    archiveTasks = [];
    emit(AppGetDataBaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        // for in loop
        if (element['status'] == 'NEW') {
          tasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archiveTasks.add(element);
        }
      });
      emit(AppGetDataBaseState());
    }).catchError((error) => print('${error.toString()}'));
  }

  void changeBottomSheetState(
      {required bool isShow, required IconData fabIcon}) {
    floatClick = isShow;
    icon = fabIcon;
    emit(AppChangeBottomSheetState());
  }

  void updateDatabase({required String status, required int id}) async {
    database.rawUpdate(
        'UPDATE tasks SET status=? WHERE id=?', [status, id]).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDataBaseState());
    }).catchError((error) => print('${error.toString()}'));
  }

  void deleteDatabase({required int id}) async {
    database.rawUpdate('DELETE FROM tasks WHERE id=$id').then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDataBaseState());
    }).catchError((error) => print('${error.toString()}'));
  }
}
