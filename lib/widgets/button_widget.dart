import 'package:flutter/material.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';

enum ButtonType {
  primary,
  secondary,
  // Có thể thêm nhiều loại nút khác ở đây
}

class AppButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isFullWidth;
  final double? width;
  final double? height;
  final bool isLoading;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final ButtonType buttonType;
  final Color? customColor; // Cho phép tùy chỉnh màu nút
  final Color? borderColor; // Màu viền cho nút
  final bool disabled; // Trạng thái vô hiệu hóa

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.buttonType = ButtonType.primary,
    this.isFullWidth = false,
    this.width,
    this.height,
    this.isLoading = false,
    this.padding,
    this.borderRadius,
    this.customColor,
    this.borderColor,
    this.disabled = false,
  });

  // Factory constructors cho các loại nút phổ biến
  factory AppButton.primary({
    Key? key,
    required String text,
    required VoidCallback onPressed,
    bool isFullWidth = false,
    double? width,
    double? height,
    bool isLoading = false,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
    Color? borderColor,
    bool disabled = false,
  }) {
    return AppButton(
      key: key,
      text: text,
      onPressed: onPressed,
      buttonType: ButtonType.primary,
      isFullWidth: isFullWidth,
      width: width,
      height: height,
      isLoading: isLoading,
      padding: padding,
      borderRadius: borderRadius,
      borderColor: borderColor,
      disabled: disabled,
    );
  }

  factory AppButton.secondary({
    Key? key,
    required String text,
    required VoidCallback onPressed,
    bool isFullWidth = false,
    double? width,
    double? height,
    bool isLoading = false,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
    Color? borderColor,
    bool disabled = false,
  }) {
    return AppButton(
      key: key,
      text: text,
      onPressed: onPressed,
      buttonType: ButtonType.secondary,
      isFullWidth: isFullWidth,
      width: width,
      height: height,
      isLoading: isLoading,
      padding: padding,
      borderRadius: borderRadius,
      borderColor: borderColor,
      disabled: disabled,
    );
  }

  // Factory constructor cho nút với màu tùy chỉnh
  factory AppButton.custom({
    Key? key,
    required String text,
    required VoidCallback onPressed,
    required Color color,
    bool isFullWidth = false,
    double? width,
    double? height,
    bool isLoading = false,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
    Color? borderColor,
    bool disabled = false,
  }) {
    return AppButton(
      key: key,
      text: text,
      onPressed: onPressed,
      buttonType:
          ButtonType.primary, // Không quan trọng vì sẽ sử dụng màu tùy chỉnh
      isFullWidth: isFullWidth,
      width: width,
      height: height,
      isLoading: isLoading,
      padding: padding,
      borderRadius: borderRadius,
      customColor: color,
      borderColor: borderColor,
      disabled: disabled,
    );
  }

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final buttonWidth = widget.isFullWidth ? double.infinity : widget.width;
    const defaultPadding = EdgeInsets.symmetric(horizontal: 24, vertical: 14);
    final defaultBorderRadius = BorderRadius.circular(12);

    // Xác định màu sắc dựa trên loại nút hoặc màu tùy chỉnh
    final Color mainColor = widget.customColor ?? _getButtonColor();
    final Color textColor = _getTextColor();
    final Color disabledBackgroundColor = _getDisabledBackgroundColor(
      mainColor,
    );
    final darkerColor = _getDarkerColor();

    // Xác định màu viền dựa trên loại nút
    final Color borderColorToUse =
        widget.borderColor ??
        (widget.buttonType == ButtonType.secondary
            ? darkerColor
            : Colors.transparent);

    return SizedBox(
      width: buttonWidth,
      height: widget.height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Lớp nền phía dưới có màu đậm hơn
          Positioned(
            left: 0,
            right: 0,
            top: 4,
            bottom: -3,
            child: Container(
              decoration: BoxDecoration(
                color: darkerColor,
                borderRadius: widget.borderRadius ?? defaultBorderRadius,
              ),
            ),
          ),
          // Nút chính
          IgnorePointer(
            ignoring: widget.disabled,
            child: GestureDetector(
              onTapDown: (_) {
                setState(() {
                  _isPressed = true;
                });
              },
              onTapUp: (_) {
                setState(() {
                  _isPressed = false;
                });
                widget.onPressed();
              },
              onTapCancel: () {
                setState(() {
                  _isPressed = false;
                });
              },
              child: SizedBox(
                width: buttonWidth,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 50),
                  transform: Matrix4.translationValues(
                    0,
                    _isPressed ? 3.0 : 0.0,
                    0,
                  ),
                  child: ElevatedButton(
                    onPressed:
                        (widget.isLoading || widget.disabled) ? null : () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainColor,
                      disabledBackgroundColor: disabledBackgroundColor,
                      padding: widget.padding ?? defaultPadding,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            widget.borderRadius ?? defaultBorderRadius,
                        side: BorderSide(
                          color: borderColorToUse,
                          width:
                              widget.buttonType == ButtonType.secondary
                                  ? 1.5
                                  : 1.0,
                        ),
                      ),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                    ),
                    child:
                        widget.isLoading
                            ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  textColor,
                                ),
                              ),
                            )
                            : TextInButton(
                              widget: widget,
                              textColor: textColor,
                            ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Phương thức để lấy màu dựa trên loại nút
  Color _getButtonColor() {
    switch (widget.buttonType) {
      case ButtonType.primary:
        return AppTheme.primaryColor;
      case ButtonType.secondary:
        return AppTheme.backgroundColor; // Đổi thành màu nền trắng
    }
  }

  // Phương thức để xác định màu chữ dựa trên loại nút
  Color _getTextColor() {
    switch (widget.buttonType) {
      case ButtonType.primary:
        return widget.disabled
            ? AppTheme.textGrayColor
            : AppTheme.backgroundColor; // Màu chữ trắng
      case ButtonType.secondary:
        return widget.disabled
            ? AppTheme.textGrayColor
            : AppTheme.textColor; // Màu chữ đen
    }
  }

  // Phương thức để lấy màu nền khi bị vô hiệu hóa
  Color _getDisabledBackgroundColor(Color baseColor) {
    switch (widget.buttonType) {
      case ButtonType.primary:
        return AppTheme.buttonPrimaryDisabledBackground;
      case ButtonType.secondary:
        return AppTheme.buttonSecondaryDisabledBackground;
    }
  }

  Color _getDarkerColor() {
    switch (widget.buttonType) {
      case ButtonType.primary:
        return widget.disabled
            ? AppTheme.buttonPrimaryDisabledDarkerColor
            : AppTheme.buttonPrimaryDarkerColor;
      case ButtonType.secondary:
        return AppTheme.buttonSecondaryDarkerColor;
    }
  }
}

class TextInButton extends StatelessWidget {
  const TextInButton({
    super.key,
    required this.widget,
    required this.textColor,
  });

  final AppButton widget;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      style: Theme.of(
        context,
      ).textTheme.displaySmall?.copyWith(color: textColor),
    );
  }
}
