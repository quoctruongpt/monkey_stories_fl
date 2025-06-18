import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/constants/level.dart';
import 'package:monkey_stories/core/routes/routes.dart';
import 'package:monkey_stories/di/injection_container.dart';
import 'package:monkey_stories/presentation/bloc/create_profile/choose_level/choose_level_cubit.dart';
import 'package:monkey_stories/presentation/widgets/create_profile/choose_level_view.dart';

final logger = Logger('ChooseLevelScreen');

class ChooseLevelScreenProvider extends StatelessWidget {
  const ChooseLevelScreenProvider({
    super.key,
    required this.name,
    required this.yearOfBirth,
    required this.source,
  });

  final String name;
  final int yearOfBirth;
  final String source;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ChooseLevelCubit>()..initTrackingData(source),
      child: ChooseLevelScreen(
        name: name,
        yearOfBirth: yearOfBirth,
        source: source,
      ),
    );
  }
}

class ChooseLevelScreen extends StatefulWidget {
  const ChooseLevelScreen({
    super.key,
    required this.name,
    required this.yearOfBirth,
    required this.source,
  });

  final String name;
  final int yearOfBirth;
  final String source;

  @override
  State<ChooseLevelScreen> createState() => _ChooseLevelScreenState();
}

class _ChooseLevelScreenState extends State<ChooseLevelScreen>
    with RouteAware, WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ModalRoute? route = ModalRoute.of(context);
    routeObserver.subscribe(this, route as PageRoute);
  }

  @override
  void didPop() {
    context.read<ChooseLevelCubit>().onBackClicked();
    context.read<ChooseLevelCubit>().trackSelectLevel();
  }

  @override
  void didPushNext() {
    context.read<ChooseLevelCubit>().trackSelectLevel();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused &&
        RouteTracker.currentRouteName ==
            AppRouteNames.createProfileChooseLevel) {
      context.read<ChooseLevelCubit>().trackSelectLevel();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  void _onContinuePressed(BuildContext context) {
    context.read<ChooseLevelCubit>().onContinueClicked();
    final uri = Uri(
      path: AppRoutePaths.createProfileLoading,
      queryParameters: {
        'name': widget.name,
        'yearOfBirth': widget.yearOfBirth.toString(),
        'levelId':
            context.read<ChooseLevelCubit>().state.levelSelected.toString(),
      },
    );

    context.go(uri.toString());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChooseLevelCubit, ChooseLevelState>(
      builder: (context, state) {
        return ChooseLevelView(
          onContinuePressed: () => _onContinuePressed(context),
          levels: onboardingLevels,
          levelSelected: state.levelSelected,
          onPressedLevel: (levelId) {
            context.read<ChooseLevelCubit>().onPressedLevel(levelId);
          },
        );
      },
    );
  }
}
