import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkey_stories/presentation/bloc/debug/debug_cubit.dart';
import 'package:monkey_stories/core/env/environment_service.dart';

class DebugViewWidget extends StatelessWidget {
  const DebugViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final environmentService = EnvironmentService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug'),
        actions: [
          BlocBuilder<DebugCubit, DebugState>(
            builder: (context, state) {
              return FilledButton(
                onPressed: () {
                  context.read<DebugCubit>().toggleDebugView();
                },
                child: const Text('Close'),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            FilledButton(
              onPressed: () {
                environmentService.showEnvironmentSelector(context);
              },
              child: const Text('Cài đặt môi trường'),
            ),
          ],
        ),
      ),
    );
  }
}
