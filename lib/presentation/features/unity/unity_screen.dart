import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/core/constants/routes_constant.dart';
import 'package:monkey_stories/core/constants/unity_constants.dart';
import 'package:monkey_stories/core/routes/routes.dart';
import 'package:monkey_stories/di/datasources.dart';
import 'package:monkey_stories/domain/entities/unity/unity_message_entity.dart';
import 'package:monkey_stories/presentation/bloc/unity/unity_cubit.dart';
import 'package:monkey_stories/presentation/bloc/dialog/dialog_cubit.dart';
import 'package:monkey_stories/presentation/bloc/playlist/playlist_cubit.dart';
import 'package:monkey_stories/presentation/bloc/unity_screen/unity_screen_cubit.dart';
import 'package:monkey_stories/presentation/widgets/parent_verify.dart';
import 'package:monkey_stories/presentation/widgets/profile/list_profile_dialog.dart';

final logger = Logger('UnityScreen');

class UnityScreen extends StatelessWidget {
  const UnityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<UnityScreenCubit>(),
      child: const UnityScreenView(),
    );
  }
}

class UnityScreenView extends StatefulWidget {
  const UnityScreenView({super.key});

  @override
  State<UnityScreenView> createState() => _UnityScreenViewState();
}

class _UnityScreenViewState extends State<UnityScreenView> with RouteAware {
  late final UnityCubit _unityCubit;

  @override
  void initState() {
    super.initState();
    _unityCubit = context.read<UnityCubit>();
    _unityCubit.registerHandler(MessageTypes.closeUnity, (
      UnityMessageEntity message,
    ) async {
      context.go(AppRoutePaths.home);
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

    _unityCubit.registerHandler(MessageTypes.buyNow, (
      UnityMessageEntity message,
    ) async {
      _handleBuyNow();
      return null;
    });

    _unityCubit.registerHandler(MessageTypes.goToPurchase, (
      UnityMessageEntity message,
    ) async {
      context.read<DialogCubit>().showDialog(
        buildVerifyDialogWidget(
          context: context,
          onSuccess: () {
            context.go(AppRoutePaths.purchased);
          },
        ),
      );
      return null;
    });

    _unityCubit.registerHandler(MessageTypes.openAudioBook, (
      UnityMessageEntity message,
    ) async {
      final playlistPayload = message.payload['playlist'] as List<dynamic>?;
      if (playlistPayload == null) {
        return null;
      }
      final playlist =
          playlistPayload.map((item) => item as Map<String, dynamic>).toList();

      context.read<PlaylistCubit>().setPlaylist(playlist);
      context.pushNamed(
        AppRouteNames.audioBook,
        queryParameters: {
          'audioSelectedId': '${message.payload['audio_selected_id']}',
        },
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
    logger.info('didPopNext');
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
    _unityCubit.unregisterHandler(MessageTypes.openAudioBook);
    _unityCubit.unregisterHandler(MessageTypes.buyNow);
    _unityCubit.unregisterHandler(MessageTypes.goToPurchase);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logger.info(context.read<UnityCubit>().state.isUnityVisible);
    return const PopScope(canPop: false, child: SizedBox.shrink());
  }

  void _handleBuyNow() {
    final dialogKey = UniqueKey();

    void closeDialog() {
      try {
        BlocProvider.of<DialogCubit>(
          context,
          listen: false,
        ).dismissDialogByKey(dialogKey);
      } catch (e) {
        logger.severe('Error dismissing ListProfileDialog: $e');
      }
    }

    context.read<DialogCubit>().showDialog(
      buildVerifyDialogWidget(
        context: context,
        onSuccess: () {
          context.read<UnityScreenCubit>().buyNow();
          closeDialog();
        },
      ),
    );
  }
}
