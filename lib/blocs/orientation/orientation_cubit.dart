import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/domain/entities/unity/unity_message_entity.dart';
import 'package:monkey_stories/domain/entities/unity/unity_payload_entity.dart';
import 'package:monkey_stories/presentation/bloc/unity/unity_cubit.dart';

part 'orientation_state.dart';

final logger = Logger('OrientationCubit');

class OrientationCubit extends Cubit<OrientationState> {
  OrientationCubit()
    : super(OrientationState(orientation: AppOrientation.portrait));

  void lockOrientation(BuildContext context, AppOrientation orientation) {
    logger.info('Lock $orientation');

    switch (orientation) {
      case AppOrientation.portrait:
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        break;
      case AppOrientation.landscapeLeft:
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
        ]);
        break;
      case AppOrientation.landscapeRight:
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
        ]);
        break;
    }
    _lockOrientationUnity(context, orientation);
    emit(state.copyWith(orientation: orientation));
  }

  void _lockOrientationUnity(BuildContext context, AppOrientation orientation) {
    final UnityMessageEntity message = UnityMessageEntity(
      type: MessageTypes.orientation,
      payload: OrientationPayloadEntity(orientation: orientation),
    );
    context.read<UnityCubit>().sendMessageToUnity(message);
  }
}
