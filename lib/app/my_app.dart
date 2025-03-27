import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/app/router.dart';
import 'package:monkey_stories/blocs/orientation/orientation_cubit.dart';
import 'package:monkey_stories/blocs/unity/unity_cubit.dart';
import 'package:monkey_stories/widgets/unity_widget.dart';

final logger = Logger("MyApp");

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UnityCubit()),
        BlocProvider(create: (context) => OrientationCubit()),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        builder: (context, child) {
          return Stack(
            children: [
              // Hiển thị nội dung chính của ứng dụng
              child ?? const SizedBox.shrink(),

              // Unity Widget sẽ đè lên UI khi cần thiết
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
          );
        },
      ),
    );
  }
}
