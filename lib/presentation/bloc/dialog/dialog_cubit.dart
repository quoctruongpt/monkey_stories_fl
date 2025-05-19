import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

part 'dialog_state.dart';

final logger = Logger('DialogCubit');

class DialogCubit extends Cubit<DialogState> {
  DialogCubit() : super(DialogInitial());

  // Hiển thị dialog mới
  void showDialog(Widget dialogWidget) {
    // Lấy key trực tiếp từ widget được truyền vào.
    // Đảm bảo widget luôn có key (do buildListProfileDialogWidget cung cấp).
    final Key dialogKey = dialogWidget.key!;

    // Tạo DialogInfo với key đã lấy được
    final newDialogInfo = DialogInfo(key: dialogKey, widget: dialogWidget);

    // Kiểm tra xem dialog với key này đã tồn tại chưa (tùy chọn, để tránh trùng lặp)
    if (state.dialogs.any((info) => info.key == dialogKey)) {
      logger.info('Dialog with key $dialogKey already exists. Skipping.');
      return; // Không thêm nếu đã có
    }

    final updatedDialogs = List<DialogInfo>.from(state.dialogs)
      ..add(newDialogInfo);
    emit(DialogsUpdated(dialogs: updatedDialogs));
    logger.info('Dialog with key $dialogKey added.'); // Thêm log xác nhận
  }

  // Đóng dialog cụ thể bằng key của nó
  void dismissDialogByKey(Key key) {
    final currentDialogs = List<DialogInfo>.from(state.dialogs);
    currentDialogs.removeWhere((dialogInfo) {
      final match = dialogInfo.key == key;
      return match;
    });
    emit(DialogsUpdated(dialogs: currentDialogs));
  }

  // Đóng dialog trên cùng (dialog được thêm vào cuối cùng)
  void dismissTopDialog() {
    if (state.dialogs.isNotEmpty) {
      final updatedDialogs = List<DialogInfo>.from(state.dialogs)..removeLast();
      emit(DialogsUpdated(dialogs: updatedDialogs));
    }
  }

  // Đóng tất cả dialog
  void dismissAllDialogs() {
    emit(const DialogsUpdated(dialogs: []));
  }
}
