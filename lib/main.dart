import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkey_stories/app/my_app.dart';
import 'package:monkey_stories/blocs/unity/unity_cubit.dart';
import 'package:monkey_stories/services/logger_service.dart';

void main() {
  Logging.setupLogging();

  runApp(BlocProvider(create: (context) => UnityCubit(), child: const MyApp()));
}
