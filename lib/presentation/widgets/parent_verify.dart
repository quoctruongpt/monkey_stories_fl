import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/di/blocs.dart';
import 'package:monkey_stories/presentation/bloc/verify_parent/verify_parent_cubit.dart';
import 'package:monkey_stories/presentation/bloc/dialog/dialog_cubit.dart';

class VerifyDialog extends StatefulWidget {
  final VoidCallback? onSuccessCallback;
  final VoidCallback? onCloseExplicitly;
  final VoidCallback? onSuccess;

  const VerifyDialog({
    super.key,
    this.onSuccessCallback,
    this.onCloseExplicitly,
    this.onSuccess,
  });

  @override
  State<VerifyDialog> createState() => _VerifyDialogState();
}

class _VerifyDialogState extends State<VerifyDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<Offset> _shakeAnimation;
  late final Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _shakeAnimation = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween(begin: const Offset(0, 0), end: const Offset(-0.05, 0)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: const Offset(-0.05, 0), end: const Offset(0.05, 0)),
        weight: 2,
      ),
      TweenSequenceItem(
        tween: Tween(begin: const Offset(0.05, 0), end: const Offset(0, 0)),
        weight: 1,
      ),
    ]).chain(CurveTween(curve: Curves.easeInOut)).animate(_animationController);

    _colorAnimation = TweenSequence<Color?>([
      TweenSequenceItem(
        tween: ColorTween(begin: AppTheme.azureColor, end: Colors.red),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.red, end: AppTheme.azureColor),
        weight: 1,
      ),
    ]).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      body: Stack(
        children: [
          BlocConsumer<VerifyParentCubit, VerifyParentState>(
            listenWhen: (previous, current) {
              if (current.randomNumbers.isEmpty) return false;

              final numberOfCharacters = current.randomNumbers.length;
              final isFull = current.input.length == numberOfCharacters;
              final wasNotFull = previous.input.length < numberOfCharacters;

              return previous.isCorrect != current.isCorrect ||
                  (wasNotFull && isFull && !current.isCorrect);
            },
            listener: (context, state) {
              if (state.isCorrect) {
                widget.onSuccessCallback?.call();
                if (widget.onSuccess != null) {
                  context.pop();
                  widget.onSuccess?.call();
                }
              } else {
                _animationController.forward(from: 0);
              }
            },
            builder: (context, state) {
              return isLandscape
                  ? _buildLandscapeLayout(context, state)
                  : _buildPortraitLayout(context, state);
            },
          ),
          Positioned(
            top: isLandscape ? 0 : 30,
            right: 0,
            child: IconButton(
              onPressed: () {
                if (widget.onCloseExplicitly != null) {
                  widget.onCloseExplicitly?.call();
                } else {
                  context.pop();
                }
              },
              icon:
                  isLandscape
                      ? SvgPicture.asset('assets/icons/svg/X.svg')
                      : const Icon(Icons.close, size: 40),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPortraitLayout(BuildContext context, VerifyParentState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Flexible(child: Image.asset('assets/images/parent_of_max.png')),

        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.md,
            vertical: Spacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                AppLocalizations.of(context).translate('app.verify.title'),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
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
              _buildInputField(context, state),
              _buildNumberPad(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLandscapeLayout(BuildContext context, VerifyParentState state) {
    return Row(
      children: [
        Flexible(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.only(bottom: Spacing.lg),
            child: Column(
              children: [
                Flexible(child: Image.asset('assets/images/parent_of_max.png')),
                const SizedBox(height: Spacing.lg),
                Text(
                  AppLocalizations.of(context).translate('app.verify.title'),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
                const SizedBox(height: Spacing.sm),
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
                const SizedBox(height: Spacing.md),
                _buildInputField(context, state),
              ],
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.md,
              vertical: Spacing.lg,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [_buildNumberPad(context)],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField(BuildContext context, VerifyParentState state) {
    final numberOfCharacters = state.randomNumbers.length;
    return SlideTransition(
      position: _shakeAnimation,
      child: AnimatedBuilder(
        animation: _colorAnimation,
        builder: (context, child) {
          return Row(
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
                              color: _colorAnimation.value,
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
                          color: _colorAnimation.value,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  context.read<VerifyParentCubit>().onBackspacePressed();
                },
                icon: Icon(
                  Icons.backspace,
                  size: 40,
                  color: _colorAnimation.value,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNumberPad(BuildContext context) {
    return SizedBox(
      height: 300,
      width: 300,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // 3 cột
          crossAxisSpacing: Spacing.md, // Khoảng cách giữa các cột
          mainAxisSpacing: Spacing.md, // Khoảng cách giữa các hàng
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
                () => context.read<VerifyParentCubit>().onNumberPressed(
                  index + 1,
                ),
            child: Text(
              (index + 1).toString(),
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w800),
            ),
          );
        },
      ),
    );
  }
}

Widget buildVerifyDialogWidget({
  required BuildContext context,
  VoidCallback? onSuccess,
}) {
  final dialogKey = UniqueKey();

  void closeDialog() {
    context.read<DialogCubit>().dismissDialogByKey(dialogKey);
  }

  void handleSuccess() {
    onSuccess?.call();
    closeDialog();
  }

  return Material(
    key: dialogKey,
    color: Colors.black.withOpacity(0.6),
    child: Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          width: double.infinity,
          height: double.infinity,
          child: BlocProvider(
            create:
                (context) => sl<VerifyParentCubit>()..generateRandomNumbers(),
            child: VerifyDialog(
              onSuccessCallback: handleSuccess,
              onCloseExplicitly: closeDialog,
            ),
          ),
        ),
      ),
    ),
  );
}

Future<void> showVerifyDialog({
  required BuildContext context,
  VoidCallback? onSuccess,
}) {
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    pageBuilder: (
      BuildContext buildContext,
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
