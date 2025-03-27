import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/blocs/unity/unity_cubit.dart';
import 'package:monkey_stories/models/orientation.dart';
import 'package:monkey_stories/models/unity.dart';
import 'package:monkey_stories/models/unity_message.dart';

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
    final UnityMessage message = UnityMessage(
      type: MessageTypes.orientation,
      payload: {'orientation': orientation.value},
    );
    context.read<UnityCubit>().sendMessageToUnity(message);
  }
}
