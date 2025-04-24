import 'package:flutter/material.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';

class TermsBottomSheet extends StatelessWidget {
  const TermsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.sm,
      ),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 8,
            decoration: BoxDecoration(
              color: AppTheme.lightGrayColor,
              borderRadius: BorderRadius.circular(Spacing.sm),
            ),
          ),
          const SizedBox(height: Spacing.lg),
          Text(
            AppLocalizations.of(context).translate('Điều khoản & chính sách'),
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: Spacing.lg),
          Text(
            AppLocalizations.of(context).translate(
              'Vui lòng xem Điều khoản sử dụng và Chính sách bảo mật để biết thêm thông tin. Đăng ký sẽ tự động gia hạn trừ khi tắt tính năng tự động gia hạn ít nhất 24 giờ trước thời hạn sử dụng. Tài khoản sẽ bị tính phí gia hạn với mức phí của gói học đã chọn trong vòng 24 giờ trước khi kết thúc thời hạn sử dụng. Bạn có thể vào phần Cài đặt trong tài khoản iTunes để quản lý đăng ký của mình và tắt tính năng tự động gia hạn. Tài khoản iTunes của bạn sẽ bị tính phí khi giao dịch mua được xác nhận. Ngay khi giao dịch mua được xác nhận, phần còn lại của bản dùng thử miễn phí sẽ không còn.',
            ),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.textGrayColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

void showTermsBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder:
        (context) => const FractionallySizedBox(
          widthFactor: 1, // full width
          child: TermsBottomSheet(),
        ),
  );
}
