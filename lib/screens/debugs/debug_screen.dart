import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkey_stories/blocs/app/app_cubit.dart';
import 'package:monkey_stories/blocs/debug/debug_cubit.dart';
import 'package:monkey_stories/models/language.dart';
import 'package:monkey_stories/services/environment_service.dart';

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
            FilledButton(
              onPressed: () {
                environmentService.showEnvironmentSelector(context);
              },
              child: const Text('Cài đặt môi trường'),
            ),
            FilledButton(
              onPressed: () {
                _showDialogChangeLanguage(context);
              },
              child: const Text('Cài đặt ngôn ngữ'),
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
