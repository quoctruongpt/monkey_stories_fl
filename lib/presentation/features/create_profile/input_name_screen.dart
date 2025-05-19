import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/di/injection_container.dart';
import 'package:monkey_stories/presentation/bloc/create_profile/input_name/input_name_cubit.dart';
import 'package:monkey_stories/presentation/widgets/base/app_bar_widget.dart';
import 'package:monkey_stories/presentation/widgets/base/button_widget.dart';
import 'package:monkey_stories/presentation/widgets/create_profile/create_profile_header.dart';
import 'package:monkey_stories/presentation/widgets/text_field/text_field_with_suffix_icon.dart';

class CreateProfileInputNameScreen extends StatelessWidget {
  const CreateProfileInputNameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<InputNameCubit>(),
      child: const CreateProfileInputNameView(),
    );
  }
}

class CreateProfileInputNameView extends StatefulWidget {
  const CreateProfileInputNameView({super.key});

  @override
  State<CreateProfileInputNameView> createState() =>
      _CreateProfileInputNameViewState();
}

class _CreateProfileInputNameViewState
    extends State<CreateProfileInputNameView> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void handleContinue() {
      context.push(
        '${AppRoutePaths.createProfileInputDateOfBirth}?name=${_nameController.text.trim()}',
      );
    }

    return Scaffold(
      appBar: const AppBarWidget(),
      body: KeyboardDismisser(
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.only(
              left: Spacing.md,
              right: Spacing.md,
              bottom: Spacing.xl,
            ),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        CreateProfileHeader(
                          title: AppLocalizations.of(
                            context,
                          ).translate('create_profile.name.title'),
                        ),

                        const SizedBox(height: Spacing.md),

                        BlocBuilder<InputNameCubit, InputNameState>(
                          builder: (context, state) {
                            return TextFieldWithSuffixIcon(
                              controller: _nameController,
                              onChanged:
                                  context.read<InputNameCubit>().onChangeName,
                              hintText: AppLocalizations.of(
                                context,
                              ).translate('create_profile.name.hint'),
                              isValid:
                                  state.name.isValid && !state.hasNameExisted,
                              isShowIcon: !state.name.isPure,
                              errorText: AppLocalizations.of(context).translate(
                                state.hasNameExisted
                                    ? 'app.create_profile.name.error_existed'
                                    : state.name.displayError,
                              ),
                              onErrorPressed: () {
                                _nameController.clear();
                              },
                              textCapitalization: TextCapitalization.words,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                BlocBuilder<InputNameCubit, InputNameState>(
                  builder: (context, state) {
                    return AppButton.primary(
                      text: AppLocalizations.of(
                        context,
                      ).translate('create_profile.name.act'),
                      onPressed: handleContinue,
                      isFullWidth: true,
                      disabled: !state.name.isValid,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
