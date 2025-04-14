import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart'; // Cần import Lottie nếu dùng
// import 'package:monkey_stories/blocs/login/login_cubit.dart'; // Không nên phụ thuộc trực tiếp vào Cubit ở đây
import 'package:monkey_stories/core/theme/app_theme.dart'; // Cần cho Spacing
import 'package:monkey_stories/core/utils/lottie_utils.dart'; // Cần cho customDecoder
import 'package:monkey_stories/presentation/widgets/button_widget.dart';
// import 'package:provider/provider.dart'; // Không cần Provider ở đây

// Định nghĩa kiểu cho hàm translate để dễ truyền hơn
typedef TranslateFunction = String Function(String key);

class NoticeDialog extends StatelessWidget {
  final String titleText;
  final String messageText;
  final String imageAsset; // Có thể là path ảnh hoặc Lottie
  final bool isLottie;
  final String primaryActionText;
  final VoidCallback? onPrimaryAction;
  final String? secondaryActionText;
  final VoidCallback? onSecondaryAction;
  final VoidCallback? onClose; // Callback cho nút X

  const NoticeDialog({
    super.key,
    required this.titleText,
    required this.messageText,
    required this.imageAsset,
    this.isLottie = false,
    required this.primaryActionText,
    this.onPrimaryAction,
    this.secondaryActionText,
    this.onSecondaryAction,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    // Logic xây dựng UI giống như _buildCustomDialogContent trước đây
    // Sử dụng các tham số đã truyền vào
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none, // Cho phép ảnh tràn ra ngoài vùng Stack chính
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
                isLottie
                    ? Lottie.asset(
                      imageAsset,
                      decoder: customDecoder,
                      width: 90, // đường kính avatar
                      height: 90,
                      fit: BoxFit.cover, // Đảm bảo Lottie vừa khít hình tròn
                    )
                    : Image.asset(
                      imageAsset,
                      width: 176,
                      height: 146,
                      fit: BoxFit.cover,
                    ),
                const SizedBox(height: Spacing.md),
                Text(
                  titleText,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.w900,
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
                const SizedBox(height: Spacing.lg),
                // Nút Primary
                AppButton.primary(
                  text: primaryActionText,
                  onPressed: onPrimaryAction ?? () {},
                  isFullWidth: true,
                  disabled: onPrimaryAction == null,
                ),
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
          Positioned(
            right: -4, // Thêm padding từ mép dialog + padding container nút
            top: -4, // Thêm margin top container + padding container nút
            child: GestureDetector(
              onTap: onClose ?? () => Navigator.of(context).pop(),
              child: SvgPicture.asset(
                'assets/icons/svg/X.svg',
                width: 48,
                height: 48,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Hàm tiện ích để hiển thị dialog này
Future<void> showCustomNoticeDialog({
  required BuildContext context,
  required String titleText,
  required String messageText,
  required String imageAsset,
  bool isLottie = false,
  required String primaryActionText,
  VoidCallback? onPrimaryAction,
  String? secondaryActionText,
  VoidCallback? onSecondaryAction,
  VoidCallback? onClose,
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
      );
    },
  );
}
