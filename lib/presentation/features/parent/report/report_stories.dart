import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/presentation/widgets/custom_pie_chart.dart';
import 'package:monkey_stories/presentation/widgets/report_card.dart';

class ReportStories extends StatelessWidget {
  const ReportStories({super.key});

  @override
  Widget build(BuildContext context) {
    return ReportCard(
      title: AppLocalizations.of(context).translate('app.report.stories.title'),
      iconWidget: SvgPicture.asset('assets/icons/svg/stories.svg'),
      child: const StoriesTabView(),
    );
  }
}

class StoriesTabView extends StatefulWidget {
  const StoriesTabView({super.key});

  @override
  State<StoriesTabView> createState() => _StoriesTabViewState();
}

class _StoriesTabViewState extends State<StoriesTabView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Data mẫu cho 2 tab
  final List<PieChartData> _weeklyData = [
    PieChartData(value: 10, label: 'Level A'),
    PieChartData(value: 10, label: 'Level B'),
    PieChartData(value: 1, label: 'Level C'),
    // PieChartData(value: 5, label: 'Level D'),
    // PieChartData(value: 0, label: 'Level E'),
  ];

  final List<PieChartData> _totalData = [
    PieChartData(value: 50, label: 'Level A'),
    PieChartData(value: 40, label: 'Level B'),
    PieChartData(value: 30, label: 'Level C'),
    PieChartData(value: 5, label: 'Level D'),
    PieChartData(value: 1, label: 'Level E'),
  ];

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
          data: _tabController.index == 0 ? _weeklyData : _totalData,
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
