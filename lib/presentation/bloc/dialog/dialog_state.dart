part of 'dialog_cubit.dart';

abstract class DialogState extends Equatable {
  final List<DialogInfo> dialogs;

  const DialogState({this.dialogs = const []});

  @override
  List<Object> get props => [dialogs];
}

class DialogInitial extends DialogState {}

class DialogsUpdated extends DialogState {
  const DialogsUpdated({required List<DialogInfo> dialogs})
    : super(dialogs: dialogs);
}

// Lớp để chứa thông tin dialog, bao gồm key để định danh
class DialogInfo extends Equatable {
  final Key key;
  final Widget widget;

  const DialogInfo({required this.key, required this.widget});

  @override
  List<Object?> get props => [key]; // Chỉ cần key để so sánh
}
