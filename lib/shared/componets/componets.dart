import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';

import '../../modules/todolist_screen/cubit/cubit.dart';

Widget defaultButton({
  double width = double.maxFinite,
  Color textColor = Colors.white,
  double textFontSize = 30,
  double height = 50,
  Color backgroundColor = Colors.red,
  bool isUpperCase = true,
  double radius = 10,
  required String text,
  required Function function,
}) =>
    Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius), color: backgroundColor),
      child: MaterialButton(
        onPressed: () {
          function();
        },
        child: Text(
          text,
          style: TextStyle(
            fontSize: textFontSize,
            color: textColor,
          ),
        ),
      ),
    );

Widget defaultTextFormField({
  required TextEditingController controller,
  required TextInputType keyboardType,
  required IconData prefixIcon,
  required String labelText,
  String hintText = '',
  Function(String)? onChanged,
  Function()? onTap,
  Function(String)? onFieldSubmitted,
  String? Function(String?)? validator,
  Function()? suffixIconOnPressed,
  bool obscureText = false,
  IconData? suffixIcon,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onChanged: onChanged,
      onTap: onTap,
      onFieldSubmitted: onFieldSubmitted,
      validator: validator,
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          hintText: hintText,
          labelText: labelText,
          prefixIcon: Icon(
            prefixIcon,
          ),
          suffixIcon: IconButton(
            onPressed: suffixIconOnPressed,
            icon: Icon(
              suffixIcon,
            ),
          )),
    );

Widget buildTaskItem(Map tasks, context) => Dismissible(
      key: Key(tasks['id'].toString()),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              child: Text(
                '${tasks['time']}',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              children: [
                Text(
                  '${tasks['title']}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff5D9CEC),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  '${tasks['date']}',
                  style: TextStyle(
                    color: Color(0xff5D9CEC),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 20,
            ),
            IconButton(
                onPressed: () {
                  AppCubit.get(context).updateDatabase(
                    status: 'done',
                    id: tasks['id'],
                  ); // update data
                },
                icon: Icon(
                  Icons.check_box,
                  color: Color(0xff5D9CEC),
                )),
            IconButton(
              onPressed: () {
                AppCubit.get(context).updateDatabase(
                  status: 'archive',
                  id: tasks['id'],
                ); // update data
              },
              icon: Icon(
                Icons.archive,
                color: Color(0xff5D9CEC),
              ),
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        AppCubit.get(context).deleteDatabase(id: tasks['id']);
      },
    );

Widget taskBuilder({required List<Map> tasks}) => ConditionalBuilder(
      condition: tasks.length > 0,
      builder: (context) => ListView.separated(
        itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
        separatorBuilder: (context, index) => Divider(),
        itemCount: tasks.length,
      ),
      fallback: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu,
              size: 60,
              color: Color(0xff5D9CEC),
            ),
            Text(
              'No Tasks Added yet ',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xff5D9CEC),
              ),
            )
          ],
        ),
      ),
    );
