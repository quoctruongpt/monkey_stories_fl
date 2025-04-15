import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkey_stories/presentation/bloc/app/app_cubit.dart';
import 'package:monkey_stories/presentation/bloc/debug/debug_cubit.dart';
import 'package:monkey_stories/presentation/bloc/float_button/float_button_cubit.dart';
import 'package:monkey_stories/core/constants/unity_constants.dart';
import 'package:monkey_stories/presentation/bloc/unity/unity_cubit.dart';

class BlocViewerScreen extends StatefulWidget {
  const BlocViewerScreen({super.key});

  @override
  State<BlocViewerScreen> createState() => _BlocViewerScreenState();
}

class _BlocViewerScreenState extends State<BlocViewerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bloc Viewer'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'App'),
            Tab(text: 'Debug'),
            Tab(text: 'Float Button'),
            Tab(text: 'Orientation'),
            Tab(text: 'Unity'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          AppCubitViewer(),
          DebugCubitViewer(),
          FloatButtonCubitViewer(),
          OrientationCubitViewer(),
          UnityCubitViewer(),
        ],
      ),
    );
  }
}

class AppCubitViewer extends StatelessWidget {
  const AppCubitViewer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return _buildStateView([
          _buildStateItem(
            'isOrientationLoading',
            '${state.isOrientationLoading}',
          ),
          _buildStateItem('languageCode', state.languageCode),
          _buildStateItem('isDarkMode', '${state.isDarkMode}'),
        ]);
      },
    );
  }
}

class DebugCubitViewer extends StatelessWidget {
  const DebugCubitViewer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DebugCubit, DebugState>(
      builder: (context, state) {
        return _buildStateView([
          _buildStateItem('isShowDebugView', '${state.isShowDebugView}'),
          _buildStateItem('isModeDebug', '${state.isModeDebug}'),
          _buildStateItem('isShowLogger', '${state.isShowLogger}'),
          _buildStateItem('logs', '${state.logs?.length ?? 0} logs'),
        ]);
      },
    );
  }
}

class FloatButtonCubitViewer extends StatelessWidget {
  const FloatButtonCubitViewer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FloatButtonCubit, FloatButtonState>(
      builder: (context, state) {
        return _buildStateView([
          _buildStateItem('x', state.x.toStringAsFixed(2)),
          _buildStateItem('y', state.y.toStringAsFixed(2)),
          _buildStateItem('targetX', state.targetX.toStringAsFixed(2)),
          _buildStateItem('targetY', state.targetY.toStringAsFixed(2)),
          _buildStateItem('isAnimating', '${state.isAnimating}'),
        ]);
      },
    );
  }
}

class OrientationCubitViewer extends StatelessWidget {
  const OrientationCubitViewer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      buildWhen:
          (previous, current) => previous.orientation != current.orientation,
      builder: (context, state) {
        String orientationText = '';
        switch (state.orientation) {
          case AppOrientation.portrait:
            orientationText = 'Portrait';
            break;
          case AppOrientation.landscapeLeft:
            orientationText = 'Landscape Left';
            break;
          case AppOrientation.landscapeRight:
            orientationText = 'Landscape Right';
            break;
        }

        return _buildStateView([
          _buildStateItem('orientation', orientationText),
        ]);
      },
    );
  }
}

class UnityCubitViewer extends StatelessWidget {
  const UnityCubitViewer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UnityCubit, UnityState>(
      builder: (context, state) {
        return _buildStateView([
          _buildStateItem('isUnityVisible', '${state.isUnityVisible}'),
        ]);
      },
    );
  }
}

Widget _buildStateView(List<Widget> items) {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items,
    ),
  );
}

Widget _buildStateItem(String name, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 14),
          ),
        ),
      ],
    ),
  );
}
