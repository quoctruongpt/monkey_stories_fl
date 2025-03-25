import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/blocs/unity/unity_cubit.dart';
import 'package:monkey_stories/screens/home_screen.dart';
import 'package:monkey_stories/widgets/unity_widget.dart';

final logger = Logger("MyApp");

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monkey Stories',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Stack(
        children: [
          const MyHomePage(title: 'Monkey Stories'),
          BlocBuilder<UnityCubit, UnityState>(
            builder: (context, state) {
              logger.info("isUnityVisible ${state.isUnityVisible}");
              return AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                left:
                    state.isUnityVisible
                        ? 0
                        : -MediaQuery.of(context).size.width,
                top: 0,
                right:
                    state.isUnityVisible
                        ? 0
                        : MediaQuery.of(context).size.width,
                bottom: 0,
                child: const UnityView(),
              );
            },
          ),
        ],
      ),
    );
  }
}
