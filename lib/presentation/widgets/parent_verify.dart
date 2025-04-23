import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/di/blocs.dart';
import 'package:monkey_stories/presentation/bloc/verify_parent/verify_parent_cubit.dart';

class VerifyDialog extends StatelessWidget {
  const VerifyDialog({super.key, this.onSuccess});

  final VoidCallback? onSuccess;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocConsumer<VerifyParentCubit, VerifyParentState>(
            listenWhen:
                (previous, current) => previous.isCorrect != current.isCorrect,
            listener: (context, state) {
              if (state.isCorrect) {
                context.pop();
                onSuccess?.call();
              }
            },
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Flexible(
                    child: Image.asset('assets/images/parent_of_max.png'),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.md,
                      vertical: Spacing.lg,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          AppLocalizations.of(
                            context,
                          ).translate('Để tiếp tục, vui lòng nhập:'),
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: AppTheme.textSecondaryColor),
                        ),
                        const SizedBox(height: Spacing.sm),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              state.randomNumbers
                                  .map(
                                    (e) => AppLocalizations.of(
                                      context,
                                    ).translate(e.toString()),
                                  )
                                  .join(' - '),
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: Spacing.md),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              children: [
                                Row(
                                  children: List.generate(
                                    numberOfCharacters,
                                    (index) => Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: SizedBox(
                                        width: 60,
                                        height: 32,
                                        child: Text(
                                          index < state.input.length
                                              ? state.input[index]
                                              : '',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.displayMedium?.copyWith(
                                            color: AppTheme.azureColor,
                                            fontSize: 32,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  children: List.generate(
                                    numberOfCharacters,
                                    (index) => Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Container(
                                        width: 60,
                                        height: 4,
                                        color: AppTheme.azureColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            IconButton(
                              onPressed: () {
                                context
                                    .read<VerifyParentCubit>()
                                    .onBackspacePressed();
                              },
                              icon: const Icon(
                                Icons.backspace,
                                size: 40,
                                color: AppTheme.azureColor,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(
                          height: 300,
                          width: 300,
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3, // 3 cột
                                  crossAxisSpacing:
                                      Spacing.md, // Khoảng cách giữa các cột
                                  mainAxisSpacing:
                                      Spacing.md, // Khoảng cách giữa các hàng
                                ),
                            padding: const EdgeInsets.all(20),
                            itemCount: 9, // 9 nút từ 1 đến 9
                            itemBuilder: (context, index) {
                              // Tạo các nút từ 1 đến 9
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.azureColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(90),
                                  ),
                                ),
                                onPressed:
                                    () => context
                                        .read<VerifyParentCubit>()
                                        .onNumberPressed(index + 1),
                                child: Text(
                                  (index + 1).toString(),
                                  style: const TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),

          Positioned(
            top: 30,
            right: 0,
            child: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: const Icon(Icons.close, size: 40),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> showVerifyDialog({
  required BuildContext context,
  VoidCallback? onSuccess,
}) {
  return showGeneralDialog<void>(
    context: context,
    pageBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
    ) {
      return BlocProvider(
        create: (context) => sl<VerifyParentCubit>()..generateRandomNumbers(),
        child: VerifyDialog(onSuccess: onSuccess),
      );
    },
  );
}
