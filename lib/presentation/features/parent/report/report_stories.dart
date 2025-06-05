import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/presentation/widgets/custom_pie_chart.dart';
import 'package:monkey_stories/presentation/widgets/report_card.dart';

class ReportStories extends StatelessWidget {
  final List<PieChartData> weeklyData;
  final List<PieChartData> totalData;

  const ReportStories({
    super.key,
    required this.weeklyData,
    required this.totalData,
  });

  @override
  Widget build(BuildContext context) {
    return ReportCard(
      title: AppLocalizations.of(context).translate('app.report.stories.title'),
      iconWidget: SvgPicture.asset('assets/icons/svg/stories.svg'),
      child: StoriesTabView(weeklyData: weeklyData, totalData: totalData),
    );
  }
}

class StoriesTabView extends StatefulWidget {
  final List<PieChartData> weeklyData;
  final List<PieChartData> totalData;
  const StoriesTabView({
    super.key,
    required this.weeklyData,
    required this.totalData,
  });

  @override
  State<StoriesTabView> createState() => _StoriesTabViewState();
}

class _StoriesTabViewState extends State<StoriesTabView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: SizedBox(
            width: 500,
            child: CustomTabBar(tabController: _tabController),
          ),
        ),
        const SizedBox(height: 36),
        CustomPieChart(
          data:
              _tabController.index == 0 ? widget.weeklyData : widget.totalData,
          emptyDataLabel: AppLocalizations.of(
            context,
          ).translate('app.report.stories.no_data'),
          otherLevelsLabel: AppLocalizations.of(
            context,
          ).translate('app.report.stories.other_levels'),
          getLabel:
              (value) => AppLocalizations.of(context).translate(
                'app.report.stories.stories',
                params: {'count': value.toString()},
              ),
        ),
      ],
    );
  }
}

class CustomTabBar extends StatelessWidget {
  final TabController tabController;

  const CustomTabBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(25),
      ),
      child: TabBar(
        controller: tabController,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          color: const Color(0xFF333741),
          borderRadius: BorderRadius.circular(25),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: const Color(0xFF475467),
        labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        tabs: [
          Tab(
            text: AppLocalizations.of(
              context,
            ).translate('app.report.stories.this_week'),
          ),
          Tab(
            text: AppLocalizations.of(
              context,
            ).translate('app.report.stories.total'),
          ),
        ],
      ),
    );
  }
}
