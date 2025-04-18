import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_embed_unity/flutter_embed_unity.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/presentation/bloc/unity/unity_cubit.dart';

final logger = Logger('UnityView');

class UnityView extends StatefulWidget {
  const UnityView({super.key});

  @override
  State<UnityView> createState() => _UnityViewState();
}

class _UnityViewState extends State<UnityView> with WidgetsBindingObserver {
  late UnityCubit _unityCubit;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _unityCubit = context.read<UnityCubit>();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _unityCubit.hideUnity();
    super.dispose();
  }

  Future<void> _handleUnityMessage(String message) async {
    await _unityCubit.handleUnityMessage(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: EmbedUnity(onMessageFromUnity: _handleUnityMessage));
  }
}
