import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:monkey_stories/core/theme/app_theme.dart'; // Cần cho Spacing
import 'package:monkey_stories/presentation/widgets/base/button_widget.dart';

// Định nghĩa kiểu cho hàm translate để dễ truyền hơn
typedef TranslateFunction = String Function(String key);

class NoticeDialog extends StatelessWidget {
  final String titleText;
  final String messageText;
  final String? imageAsset; // Có thể là path ảnh hoặc Lottie
  final bool isLottie;
  final String? primaryActionText;
  final VoidCallback? onPrimaryAction;
  final String? secondaryActionText;
  final VoidCallback? onSecondaryAction;
  final VoidCallback? onClose; // Callback cho nút X
  final bool isCloseable;
  final Color? titleColor;
  final bool canPopOnBack;
  final Widget? child;

  const NoticeDialog({
    super.key,
    required this.titleText,
    required this.messageText,
    this.imageAsset,
    this.isLottie = false,
    this.primaryActionText,
    this.onPrimaryAction,
    this.secondaryActionText,
    this.onSecondaryAction,
    this.onClose,
    this.isCloseable = true,
    this.titleColor,
    this.canPopOnBack = true,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Logic xây dựng UI giống như _buildCustomDialogContent trước đây
    // Sử dụng các tham số đã truyền vào
    return PopScope(
      canPop: canPopOnBack,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Stack(
          clipBehavior:
              Clip.none, // Cho phép ảnh tràn ra ngoài vùng Stack chính
          alignment: Alignment.topCenter, // Căn ảnh ở trên cùng giữa
          children: <Widget>[
            // Container chứa nội dung text và button
            Container(
              padding: const EdgeInsets.all(Spacing.lg),

              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.circular(32.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: Offset(0.0, 10.0),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  imageAsset != null
                      ? Image.asset(
                        imageAsset!,
                        width: 176,
                        height: 146,
                        fit: BoxFit.cover,
                      )
                      : const SizedBox.shrink(),
                  const SizedBox(height: Spacing.md),
                  Text(
                    titleText,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: titleColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: Spacing.md),
                  Text(
                    messageText,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child ?? const SizedBox.shrink(),
                  const SizedBox(height: Spacing.lg),
                  // Nút Primary
                  primaryActionText != null
                      ? AppButton.primary(
                        text: primaryActionText!,
                        onPressed: onPrimaryAction ?? () {},
                        isFullWidth: true,
                        disabled: onPrimaryAction == null,
                      )
                      : const SizedBox.shrink(),
                  const SizedBox(height: Spacing.md),
                  // Nút Secondary
                  secondaryActionText != null
                      ? AppButton.secondary(
                        text: secondaryActionText!,
                        onPressed: onSecondaryAction ?? () {},
                        isFullWidth: true,
                        disabled: onSecondaryAction == null,
                      )
                      : const SizedBox.shrink(),
                ],
              ),
            ),

            // Nút đóng (X)
            isCloseable
                ? Positioned(
                  right:
                      -4, // Thêm padding từ mép dialog + padding container nút
                  top: -4, // Thêm margin top container + padding container nút
                  child: GestureDetector(
                    onTap: onClose ?? () => Navigator.of(context).pop(),
                    child: SvgPicture.asset(
                      'assets/icons/svg/X.svg',
                      width: 48,
                      height: 48,
                    ),
                  ),
                )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

// Hàm tiện ích để hiển thị dialog này
Future<void> showCustomNoticeDialog({
  required BuildContext context,
  required String titleText,
  required String messageText,
  String? imageAsset,
  bool isLottie = false,
  String? primaryActionText,
  VoidCallback? onPrimaryAction,
  String? secondaryActionText,
  VoidCallback? onSecondaryAction,
  VoidCallback? onClose,
  bool isCloseable = true,
  Color? titleColor,
  bool canPopOnBack = true,
  Widget? child,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      // Truyền các tham số và callback vào widget dialog
      // Sử dụng dialogContext để pop khi cần thiết bên trong các callback
      return NoticeDialog(
        titleText: titleText,
        messageText: messageText,
        imageAsset: imageAsset,
        isLottie: isLottie,
        primaryActionText: primaryActionText,
        onPrimaryAction:
            onPrimaryAction != null
                ? () {
                  // Navigator.of(dialogContext).pop(); // Không pop ở đây, để nơi gọi quyết định
                  onPrimaryAction();
                }
                : null,
        secondaryActionText: secondaryActionText,
        onSecondaryAction:
            onSecondaryAction != null
                ? () {
                  // Navigator.of(dialogContext).pop();
                  onSecondaryAction();
                }
                : null,
        onClose:
            onClose != null
                ? () {
                  onClose();
                }
                : () => Navigator.of(dialogContext).pop(), // Mặc định chỉ đóng
        isCloseable: isCloseable,
        titleColor: titleColor,
        canPopOnBack: canPopOnBack,
        child: child,
      );
    },
  );
}
