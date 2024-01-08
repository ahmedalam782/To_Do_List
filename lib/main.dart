import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list_amit/layout/todolist/todolist_screen.dart';
import 'package:to_do_list_amit/modules/todolist_screen/cubit/cubit.dart';
import 'package:to_do_list_amit/modules/todolist_screen/cubit/state.dart';
import 'package:to_do_list_amit/shared/network/local/cache_helper.dart';
import 'package:to_do_list_amit/shared/styles/bloc_observer.dart';

void main() async {
  Bloc.observer = const SimpleBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await CashHelper.init();
  bool? isDark = await CashHelper.getData(key: 'isDark');
  runApp(MyToDoApp(
    isDark: isDark,
  ));
}

class MyToDoApp extends StatelessWidget {
  bool? isDark;

  MyToDoApp({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()
        ..createDatabase()
        ..changeAppMode(forShared: isDark),
      child: BlocConsumer<AppCubit, AppStates>(
        builder: (BuildContext context, AppStates state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                appBarTheme: AppBarTheme(
                    backgroundColor: Color(0xff5D9CEC), elevation: 0),
                floatingActionButtonTheme: FloatingActionButtonThemeData(
                  backgroundColor: Color(0xff5D9CEC),
                ),
                bottomNavigationBarTheme: BottomNavigationBarThemeData(
                  selectedItemColor: Color(0xff5D9CEC),
                  backgroundColor: Colors.white,
                )),
            darkTheme: ThemeData(
              bottomSheetTheme: BottomSheetThemeData(
                backgroundColor: Color(0xff282828),
              ),
              scaffoldBackgroundColor: Color(0xff282828),
              appBarTheme:
                  AppBarTheme(backgroundColor: Color(0xff5D9CEC), elevation: 0),
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: Color(0xff5D9CEC),
              ),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                selectedItemColor: Color(0xff5D9CEC),
                backgroundColor: Color(0xff141922),
                unselectedItemColor: Colors.white,
              ),
            ),
            themeMode:
                AppCubit.get(context).isDark ? ThemeMode.dark : ThemeMode.light,
            home: ToDoListScreen(),
          );
        },
        listener: (BuildContext context, AppStates state) {},
      ),
    );
  }
}
