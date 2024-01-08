import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../modules/todolist_screen/cubit/cubit.dart';
import '../../modules/todolist_screen/cubit/state.dart';
import '../../shared/componets/componets.dart';
import '../../shared/componets/constant.dart';

class ToDoListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(listener: (context, state) {
      if (state is AppInsertDataBaseState) {
        Navigator.pop(context);
      }
    }, builder: (context, state) {
      AppCubit cubit = AppCubit.get(context);
      return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          leading: Icon(
            Icons.task,
            color: Colors.white,
          ),
          title: Text(
            cubit.text[cubit.currentIndex],
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                cubit.changeAppMode();
                cubit.getDataFromDatabase(cubit.database);
              },
              icon: Icon(
                Icons.dark_mode,
                color: Colors.white,
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (cubit.floatClick) {
              if (formKey.currentState!.validate()) {
                cubit.insertDatabase(
                  title: titleEditingController.text,
                  date: dateEditingController.text,
                  time: timeEditingController.text,
                );
              }
            } else {
              scaffoldKey.currentState!
                  .showBottomSheet((context) => Container(
                        color: Colors.grey[100],
                        child: Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: Form(
                            key: formKey,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  defaultTextFormField(
                                    controller: titleEditingController,
                                    keyboardType: TextInputType.text,
                                    prefixIcon: Icons.title,
                                    labelText: 'Task Title',
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Title must not be empty';
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  defaultTextFormField(
                                    controller: timeEditingController,
                                    keyboardType: TextInputType.text,
                                    prefixIcon: Icons.watch_later_outlined,
                                    labelText: 'Task Time',
                                    onTap: () => showTimePicker(
                                      initialEntryMode:
                                          TimePickerEntryMode.inputOnly,
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then(
                                      (value) => timeEditingController.text =
                                          value!.format(context).toString(),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Time must not be empty';
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  defaultTextFormField(
                                    controller: dateEditingController,
                                    keyboardType: TextInputType.datetime,
                                    prefixIcon: Icons.calendar_today,
                                    labelText: 'Task Date',
                                    onTap: () => showDatePicker(
                                      initialEntryMode:
                                          DatePickerEntryMode.calendarOnly,
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime(2099),
                                    ).then((value) =>
                                        dateEditingController.text =
                                            DateFormat.yMMMd()
                                                .format(value!)
                                                .toString()),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Date must not be empty';
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ))
                  .closed
                  .then((value) {
                cubit.changeBottomSheetState(
                  isShow: false,
                  fabIcon: Icons.edit,
                );
                titleEditingController.clear();
                timeEditingController.clear();
                dateEditingController.clear();
              });
              cubit.changeBottomSheetState(
                isShow: true,
                fabIcon: Icons.add,
              );
            }
          },
          child: Icon(
            cubit.icon,
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: cubit.currentIndex,
          onTap: (index) {
            cubit.changeIndex(index);
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.menu,
                ),
                label: 'Tasks'),
            BottomNavigationBarItem(
              icon: Icon(Icons.check_circle),
              label: 'Done',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.archive,
              ),
              label: 'Archive',
            ),
          ],
        ),
        body: ConditionalBuilder(
          condition: state is! AppGetDataBaseLoadingState,
          builder: (context) => cubit.screens[cubit.currentIndex],
          fallback: (context) => Center(
              child: CircularProgressIndicator(
            color: Colors.orangeAccent,
          )),
        ),
      );
    });
  }
}
