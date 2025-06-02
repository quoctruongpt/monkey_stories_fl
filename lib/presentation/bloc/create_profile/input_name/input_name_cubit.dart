import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:monkey_stories/core/validators/name.dart';
import 'package:monkey_stories/domain/usecases/tracking/sign_up/ms_profile_name.dart';
import 'package:monkey_stories/presentation/bloc/account/profile/profile_cubit.dart';

part 'input_name_state.dart';

class InputNameTrackingData {
  String source = '';
  MsProfileNameClickType clickType = MsProfileNameClickType.none;
  String? errorMessage;
}

class InputNameCubit extends Cubit<InputNameState> {
  final ProfileCubit _profileCubit;
  final MsProfileNameTrackingUsecase _msProfileNameTrackingUsecase;

  final _inputNameTrackingData = InputNameTrackingData();

  InputNameCubit({
    required ProfileCubit profileCubit,
    required MsProfileNameTrackingUsecase msProfileNameTrackingUsecase,
  }) : _profileCubit = profileCubit,
       _msProfileNameTrackingUsecase = msProfileNameTrackingUsecase,
       super(const InputNameState(name: NameValidator.pure()));

  void initTrackingData(String source) {
    _inputNameTrackingData.source = source;
  }

  void onChangeName(String value) {
    final name = NameValidator.dirty(value);
    emit(state.copyWith(name: name, hasNameExisted: hasNameExisted(value)));
  }

  bool hasNameExisted(String name) {
    return _profileCubit.state.profiles.any(
      (profile) => profile.name == name.trim(),
    );
  }

  void onContinueClicked() {
    _inputNameTrackingData.clickType = MsProfileNameClickType.continueClick;
  }

  void onBackClicked() {
    _inputNameTrackingData.clickType = MsProfileNameClickType.back;
  }

  void trackProfileName() {
    _msProfileNameTrackingUsecase.call(
      MsProfileNameTrackingParams(
        source: _inputNameTrackingData.source,
        clickType: _inputNameTrackingData.clickType,
        haveOccurredError: _inputNameTrackingData.errorMessage != null,
        errorMessage: _inputNameTrackingData.errorMessage,
      ),
    );
  }
}
