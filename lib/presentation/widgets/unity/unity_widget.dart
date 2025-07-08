// Dart imports:
import 'dart:convert';
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_embed_unity/flutter_embed_unity.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';

// Project imports:
import 'package:monkey_stories/presentation/bloc/purchased/purchased_cubit.dart';
import 'package:monkey_stories/presentation/bloc/unity/unity_cubit.dart';
import 'package:monkey_stories/presentation/widgets/base/button_widget.dart';
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

  Future<String> _copyAudioFileToDocuments(String audioName) async {
    try {
      // Lấy thư mục documents của thiết bị
      final Directory documentsDir = await getApplicationDocumentsDirectory();

      // Tạo thư mục audio nếu chưa tồn tại
      final Directory audioDir = Directory('${documentsDir.path}/audio');
      if (!await audioDir.exists()) {
        await audioDir.create(recursive: true);
      }

      // Đường dẫn file đích
      final String destinationPath = '${audioDir.path}/$audioName.mp3';

      // Load file từ assets
      final ByteData data = await rootBundle.load(
        'assets/audio/$audioName.mp3',
      );
      final List<int> bytes = data.buffer.asUint8List();

      // Ghi file vào thư mục documents
      final File destinationFile = File(destinationPath);
      await destinationFile.writeAsBytes(bytes);

      logger.info('Đã copy file xyz.mp3 vào: $destinationPath');

      return destinationPath;
    } catch (e) {
      logger.severe('Lỗi khi copy file: $e');

      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(body: EmbedUnity(onMessageFromUnity: _handleUnityMessage)),
        BlocBuilder<PurchasedCubit, PurchasedState>(
          builder: (context, state) {
            return state.isPurchasing
                ? const LoadingOverlay()
                : const SizedBox.shrink();
          },
        ),

        AppButton.primary(
          text: 'Audio Book',
          onPressed: () async {
            // Copy file vào thư mục documents
            final audioPath1 = await _copyAudioFileToDocuments('xyz');
            final audioPath2 = await _copyAudioFileToDocuments('aaa');

            _handleUnityMessage(
              jsonEncode({
                'id': '1234',
                'type': 'audio_book',
                'payload': {
                  // "audio_selected_id": 777,
                  'playlist': [
                    {
                      'id': 776,
                      'name': 'July and Julia',
                      'content':
                          'July has a twin sister, Julia.\r\nThey look a lot alike.\r\nThey have the same clothes, purses and shoes.\r\nThey have the same friends to play with.\r\nThey do the same homework from school.\r\nThey help each other.\r\nThey talk about dreams.\r\n*"I want to be a doctor in the future,"* July said.\r\n*"I want to become a teacher,"* said Julia.\r\nThey go to the zoo and look at the same animals.\r\nJuly and Julia are not only siblings, but they are also best friends!',
                      'duration': 277,
                      'isDownloaded': true,
                      'localAudioPath': audioPath1,
                      'localThumbPath': 'assets/images/purchased.png',
                      'isFree': true,
                    },
                    {
                      'id': 777,
                      'name': 'The Shilling',
                      'content':
                          "In a small town, there lived a good boy named George. One day, George’s uncle gave him a shilling. Like other boys, George was very excited and dreamed about all the things he could buy with that money. However, because he wanted so many things, it was hard to make a choice.\n\nAs he sat at the front door, George thought about what to do with one shilling. Just then, a woman carrying a box walked by. Inside the box were many little glass toys in different animal shapes. They all looked beautiful and curious. \n\n*“How much is this?”* George asked excitedly, pointing to a peacock.\n*“Two shillings,”* answered the toy seller.\n*“But I've only got one shilling,”* responded George.\n*“Well, I have some toys that cost a shilling. Do you like this robin redbreast? Or maybe this deer, or this sheep?”* the toy seller suggested.\n\nThe toy seller kept trying to persuade George to buy other toys that cost only one shilling, but George liked the peacock best of all. He did not want anything else. Suddenly, George saw an old man sitting on the other side of the street. The man desperately begged people for money but received nothing. He looked sick, feeble and very poor.\n\nGeorge felt very sorry for the man and decided to help him.\n*“That poor old man! I shall give him my shilling!”* exclaimed George.\nHe crossed the street, placed the shilling in the old man's hand and said, *“I was about to spend this money on a glass toy that would be broken in a day. Now I want to use it for a better purpose. Take it and buy yourself some food.”*\nThe poor old man was surprised and moved by George’s good deed. He said, *“Thank you, my young master! May all good things come your way, as you did to me.”*\n\nEven though George did not get his favorite toy, he was glad he had helped somebody with his one shilling. He walked back to his house in a jolly mood and had no idea the toy seller had witnessed everything he had just done.\n*“Well done, good boy!”* said the toy seller when George returned. *“Thanks to you, that man will not be hungry today. As a reward for your generosity and selflessness, here is the peacock you wanted so much.”*\n\nGeorge did not expect this. He was over the moon and enthralled to receive the little glass toy. He took careful care of the glass bird, as it was not only his favorite toy but also a reminder of his good deed.",
                      'duration': 277,
                      'isDownloaded': true,
                      'localAudioPath': audioPath2,
                      'localThumbPath': 'assets/images/purchased.png',
                      'isFree': false,
                    },
                  ],
                },
              }),
            );
          },
        ),
      ],
    );
  }
}
