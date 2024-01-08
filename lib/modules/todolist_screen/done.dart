import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/componets/componets.dart';
import 'cubit/cubit.dart';
import 'cubit/state.dart';

class Done extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      builder: (context, state) {
        var doneTasks = AppCubit.get(context).doneTasks;
        return taskBuilder(tasks: doneTasks);
      },
      listener: (context, state) {},
    );
  }
}
