import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/componets/componets.dart';
import 'cubit/cubit.dart';
import 'cubit/state.dart';

class Tasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      builder: (context, state) {
        var tasks = AppCubit.get(context).tasks;
        return taskBuilder(tasks: tasks);
      },
      listener: (context, state) {},
    );
  }
}
