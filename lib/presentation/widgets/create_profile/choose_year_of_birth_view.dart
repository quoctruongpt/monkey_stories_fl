import 'package:flutter/material.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/presentation/widgets/base/app_bar_widget.dart';
import 'package:monkey_stories/presentation/widgets/base/button_widget.dart';
import 'package:monkey_stories/presentation/widgets/create_profile/create_profile_footer.dart';
import 'package:monkey_stories/presentation/widgets/create_profile/create_profile_header.dart';
import 'package:monkey_stories/presentation/widgets/year_button.dart';

class ChooseYearOfBirthView extends StatefulWidget {
  const ChooseYearOfBirthView({
    super.key,
    required this.name,
    required this.onPressedContinue,
    this.yearSelected,
    required this.onChangeYear,
    required this.years,
  });

  final String name;
  final void Function(int year) onPressedContinue;
  final int? yearSelected;
  final void Function(int year) onChangeYear;
  final List<int> years;

  @override
  State<ChooseYearOfBirthView> createState() => _ChooseYearOfBirthViewState();
}

class _ChooseYearOfBirthViewState extends State<ChooseYearOfBirthView>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    // Ensure the animation only starts after the delay
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        // Check if the widget is still in the tree
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(),
      body: SafeArea(
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
                        title: AppLocalizations.of(context).translate(
                          'create_profile.year_of_birth.title',
                          params: {'Name': widget.name},
                        ),
                      ),
                      const SizedBox(height: Spacing.md),
                      SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Column(
                            children: [
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  const crossAxisCount = 4;
                                  const spacing = Spacing.sm;
                                  final totalSpacing =
                                      spacing * (crossAxisCount - 1);
                                  final itemWidth =
                                      (constraints.maxWidth - totalSpacing) /
                                      crossAxisCount;

                                  return Wrap(
                                    spacing: spacing,
                                    runSpacing: spacing,
                                    children: List.generate(
                                      12,
                                      (index) => SizedBox(
                                        width: itemWidth,
                                        child: buildYearButton(
                                          context,
                                          widget.years[index],
                                          widget.yearSelected ==
                                              widget.years[index],
                                          () => widget.onChangeYear(
                                            widget.years[index],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: buildYearButton(
                                  context,
                                  widget.years[12],
                                  widget.yearSelected == widget.years[12],
                                  () => widget.onChangeYear(widget.years[12]),
                                  customText: AppLocalizations.of(
                                    context,
                                  ).translate(
                                    'year.before',
                                    params: {
                                      'year': widget.years[12].toString(),
                                    },
                                  ),
                                ),
                              ),
                              const CreateProfileFooter(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              AppButton.primary(
                text: AppLocalizations.of(
                  context,
                ).translate('create_profile.year_of_birth.act'),
                onPressed: () => widget.onPressedContinue(widget.yearSelected!),
                disabled: widget.yearSelected == null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
