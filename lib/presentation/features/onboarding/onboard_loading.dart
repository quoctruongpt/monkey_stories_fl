import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/core/constants/routes_constant.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/presentation/bloc/onboarding/onboarding_cubit.dart';
import 'package:monkey_stories/presentation/widgets/base/notice_dialog.dart';
import 'package:monkey_stories/presentation/widgets/create_profile_loading_view.dart';

class OnboardLoading extends StatefulWidget {
  const OnboardLoading({super.key});

  @override
  State<OnboardLoading> createState() => _OnboardLoadingState();
}

class _OnboardLoadingState extends State<OnboardLoading> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OnboardingCubit>().onStart();
    });
  }

  void _onError(OnboardingError error) {
    showCustomNoticeDialog(
      context: context,
      titleText: 'Lỗi',
      messageText: 'Có lỗi xảy ra, vui lòng thử lại',
      imageAsset: 'assets/images/monkey_sad.png',
      primaryActionText: 'Tôi đã hiểu',
      onPrimaryAction: () {
        if (error.onboardingProgress == OnboardingProgress.createAccount) {
          context.go(AppRoutePaths.intro);
        } else {
          context.go(AppRoutePaths.home);
        }
      },
      isCloseable: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingCubit, OnboardingState>(
      listenWhen: (previous, current) {
        return previous.error != current.error && current.error != null;
      },
      listener: (context, state) {
        _onError(state.error!);
      },
      child: BlocListener<OnboardingCubit, OnboardingState>(
        listenWhen:
            (previous, current) => previous.progress != current.progress,
        listener: (context, state) {
          if (state.progress == 1) {
            context.go(AppRoutePaths.home);
          }
        },
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
            child: BlocBuilder<OnboardingCubit, OnboardingState>(
              builder: (context, state) {
                return CreateProfileLoadingView(progress: state.progress);
              },
            ),
          ),
        ),
      ),
    );
  }
}
