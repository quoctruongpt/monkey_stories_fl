import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/presentation/bloc/app/app_cubit.dart';
import 'package:monkey_stories/presentation/bloc/debug/debug_cubit.dart';
import 'package:monkey_stories/core/constants/language.dart';
import 'package:monkey_stories/core/env/environment_service.dart';

class DebugScreen extends StatelessWidget {
  const DebugScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final environmentService = EnvironmentService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug'),
        actions: [const DebugActions()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                icon: const Icon(Icons.cloud_outlined),
                onPressed: () {
                  environmentService.showEnvironmentSelector(context);
                },
                label: const Text('Cài đặt môi trường'),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                icon: const Icon(Icons.language),
                onPressed: () {
                  _showDialogChangeLanguage(context);
                },
                label: const Text('Cài đặt ngôn ngữ'),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                icon: const Icon(Icons.article_outlined),
                onPressed: () {
                  context.push('/logger');
                },
                label: const Text('Logger'),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                icon: const Icon(Icons.storage),
                onPressed: () {
                  context.push('/shared-prefs');
                },
                label: const Text('Shared Preferences'),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                icon: const Icon(Icons.memory),
                onPressed: () {
                  context.push('/bloc-viewer');
                },
                label: const Text('Bloc Viewer'),
              ),
            ),
            BlocBuilder<DebugCubit, DebugState>(
              builder: (context, state) {
                return SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    icon: Icon(
                      state.isShowLogger ? Icons.toggle_on : Icons.toggle_off,
                    ),
                    onPressed: () {
                      context.read<DebugCubit>().toggleLogger();
                    },
                    label: Text('Bật logger: ${state.isShowLogger}'),
                  ),
                );
              },
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                icon: const Icon(Icons.network_check),
                onPressed: () {
                  context.push('/network-logger');
                },
                label: const Text('Network Logger'),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                icon: const Icon(Icons.settings_remote),
                onPressed: () {
                  context.push('/remote-config');
                },
                label: const Text('Remote Config'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDialogChangeLanguage(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Thay đổi ngôn ngữ'),
          content: SizedBox(
            width: double.minPositive,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  Languages.supportedLanguages.map((language) {
                    return ListTile(
                      title: Text(language.name),
                      subtitle: Text(language.localName),
                      onTap: () {
                        context.read<AppCubit>().changeLanguage(language.code);
                        Navigator.of(context).pop();
                      },
                    );
                  }).toList(),
            ),
          ),
        );
      },
    );
  }
}

class DebugActions extends StatelessWidget {
  const DebugActions({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DebugCubit, DebugState>(
      builder: (context, state) {
        return FilledButton(
          onPressed: () {
            context.read<DebugCubit>().toggleDebugView();
          },
          child: const Text('Close'),
        );
      },
    );
  }
}
