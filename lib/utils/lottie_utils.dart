import 'dart:async';

import 'package:collection/collection.dart';
import 'package:lottie/lottie.dart';

/// Custom Lottie decoder to select the correct JSON file from a .lottie archive.
///
/// Assumes the main animation JSON file is located within an 'animations/'
/// directory inside the archive and ends with '.json'.
Future<LottieComposition?> customDecoder(List<int> bytes) {
  return LottieComposition.decodeZip(
    bytes,
    filePicker: (files) {
      return files.firstWhereOrNull(
        (f) => f.name.startsWith('animations/') && f.name.endsWith('.json'),
      );
    },
  );
}
