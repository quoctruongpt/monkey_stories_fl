import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_embed_unity/flutter_embed_unity.dart';
import 'package:logging/logging.dart';
import 'package:monkey_stories/core/constants/unity_constants.dart';
import 'package:monkey_stories/presentation/bloc/purchased/purchased_cubit.dart';
import 'package:monkey_stories/presentation/bloc/unity/unity_cubit.dart';
import 'package:monkey_stories/presentation/widgets/loading/loading_overlay.dart';

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
  }

  @override
  void initState() {
    super.initState();
    _unityCubit = context.read<UnityCubit>();
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
    return Stack(
      children: [
        Scaffold(body: EmbedUnity(onMessageFromUnity: _handleUnityMessage)),
        Positioned(
          top: 100,
          left: 0,
          right: 0,
          child: FilledButton(
            onPressed: () {
              _handleUnityMessage(
                const JsonEncoder.withIndent('').convert({
                  'type': MessageTypes.openListProfile,
                  'payload': null,
                }),
              );
            },
            child: const Text('Parent'),
          ),
        ),
        Positioned(
          top: 150,
          left: 0,
          right: 0,
          child: FilledButton(
            onPressed: () {
              _handleUnityMessage(
                const JsonEncoder.withIndent(
                  '',
                ).convert({'type': MessageTypes.buyNow, 'payload': null}),
              );
            },
            child: const Text('Buy Now'),
          ),
        ),
        Positioned(
          top: 200,
          left: 0,
          right: 0,
          child: FilledButton(
            onPressed: () {
              _handleUnityMessage(
                const JsonEncoder.withIndent(
                  '',
                ).convert({'type': MessageTypes.closeUnity, 'payload': null}),
              );
            },
            child: const Text('Close'),
          ),
        ),
        Positioned(
          top: 250,
          left: 0,
          right: 0,
          child: FilledButton(
            onPressed: () {
              _handleUnityMessage(
                const JsonEncoder.withIndent(
                  '',
                ).convert({'type': MessageTypes.goToPurchase, 'payload': null}),
              );
            },
            child: const Text('Mua'),
          ),
        ),
        Positioned(
          top: 300,
          left: 0,
          right: 0,
          child: FilledButton(
            onPressed: () {
              _handleUnityMessage(
                const JsonEncoder.withIndent('').convert({
                  'type': MessageTypes.openAudioBook,
                  'payload': {
                    // "audio_selected_id": 777,
                    "playlist": [
                      {
                        "id": 776,
                        "name": "The Shilling",
                        "duration": 277,
                        "isDownloaded": true,
                        "localAudioPath": "assets/audio/aaa.mp3",
                        "localSyncTextPath": "assets/data/sync_text.json",
                        "localThumbPath": "assets/images/purchased.png",
                        "isFree": true,
                      },
                      {
                        "id": 777,
                        "name": "Another Unloaded Story",
                        "duration": 185,
                        "isDownloaded": true,
                        "localAudioPath": "assets/audio/aaa.mp3",
                        "localSyncTextPath": "assets/data/sync_text.json",
                        "localThumbPath": "assets/images/purchased.png",
                        "isFree": true,
                      },
                      {
                        "id": 778,
                        "name": "Một con vịt",
                        "duration": 185,
                        "isDownloaded": false,
                        "localAudioPath": null,
                        "localSyncTextPath": null,
                        "localThumbPath": "assets/images/purchased.png",
                        "isFree": false,
                      },
                      {
                        "id": 779,
                        "name": "Hai con vịt",
                        "duration": 185,
                        "isDownloaded": false,
                        "localAudioPath": null,
                        "localSyncTextPath": null,
                        "localThumbPath": "assets/images/purchased.png",
                        "isFree": false,
                      },
                      {
                        "id": 780,
                        "name": "Ba con vịt",
                        "duration": 185,
                        "isDownloaded": false,
                        "localAudioPath": null,
                        "localSyncTextPath": null,
                        "localThumbPath": "assets/images/purchased.png",
                        "isFree": false,
                      },
                      {
                        "id": 781,
                        "name": "Bốn con vịt",
                        "duration": 185,
                        "isDownloaded": false,
                        "localAudioPath": null,
                        "localSyncTextPath": null,
                        "localThumbPath": "assets/images/purchased.png",
                        "isFree": false,
                      },
                      {
                        "id": 782,
                        "name": "Năm con vịt",
                        "duration": 185,
                        "isDownloaded": false,
                        "localAudioPath": null,
                        "localSyncTextPath": null,
                        "localThumbPath": "assets/images/purchased.png",
                        "isFree": false,
                      },
                    ],
                  },
                }),
              );
            },
            child: const Text('Audio Book'),
          ),
        ),

        BlocBuilder<PurchasedCubit, PurchasedState>(
          builder: (context, state) {
            return state.isPurchasing
                ? const LoadingOverlay()
                : const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
