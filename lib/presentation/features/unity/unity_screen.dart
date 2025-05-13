import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/core/constants/unity_constants.dart';
import 'package:monkey_stories/core/routes/routes.dart';
import 'package:monkey_stories/domain/entities/unity/unity_message_entity.dart';
import 'package:monkey_stories/presentation/bloc/unity/unity_cubit.dart';
import 'package:monkey_stories/presentation/bloc/dialog/dialog_cubit.dart';
import 'package:monkey_stories/presentation/widgets/profile/list_profile_dialog.dart';

final logger = Logger('UnityScreen');

class UnityScreen extends StatefulWidget {
  const UnityScreen({super.key});

  @override
  State<UnityScreen> createState() => _UnityScreenState();
}

class _UnityScreenState extends State<UnityScreen> with RouteAware {
  late final UnityCubit _unityCubit;

  @override
  void initState() {
    super.initState();
    _unityCubit = context.read<UnityCubit>();
    _unityCubit.registerHandler(MessageTypes.closeUnity, (
      UnityMessageEntity message,
    ) async {
      context.pop();
      return null;
    });
    _unityCubit.registerHandler(MessageTypes.openListProfile, (
      UnityMessageEntity message,
    ) async {
      context.read<DialogCubit>().showDialog(
        buildListProfileDialogWidget(context),
      );
      return null;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ModalRoute? modalRoute = ModalRoute.of(context);
    if (modalRoute is PageRoute) {
      routeObserver.subscribe(this, modalRoute);
    }
  }

  @override
  void didPush() {
    final message = const UnityMessageEntity(
      type: MessageTypes.openUnity,
      payload: {'destination': 'map_lesson'},
    );
    _unityCubit.sendMessageToUnity(message);
    _unityCubit.showUnity();
  }

  @override
  void didPopNext() {
    _unityCubit.showUnity();
  }

  @override
  void didPushNext() {
    _unityCubit.hideUnity();
  }

  @override
  void didPop() {
    _unityCubit.hideUnity();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _unityCubit.unregisterHandler(MessageTypes.closeUnity);
    _unityCubit.unregisterHandler(MessageTypes.openListProfile);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const PopScope(canPop: false, child: SizedBox.shrink());
  }
}
