import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/localization/app_localizations.dart';
import 'package:monkey_stories/core/theme/app_theme.dart';
import 'package:monkey_stories/core/utils/permission.dart';
import 'package:monkey_stories/presentation/bloc/active_license/active_license_cubit.dart';
import 'package:monkey_stories/presentation/widgets/base/app_bar_widget.dart';
import 'package:monkey_stories/presentation/widgets/base/button_widget.dart';
import 'package:monkey_stories/presentation/widgets/base/notice_dialog.dart';
import 'package:monkey_stories/presentation/widgets/loading/loading_overlay.dart';
import 'package:monkey_stories/presentation/widgets/text_field/text_field_widget.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class InputLicense extends StatefulWidget {
  const InputLicense({super.key});

  @override
  State<InputLicense> createState() => _InputLicenseState();
}

class _InputLicenseState extends State<InputLicense> {
  final TextEditingController _controller = TextEditingController();
  final MobileScannerController _cameraController = MobileScannerController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _cameraController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: MultiBlocListener(
        listeners: [
          BlocListener<ActiveLicenseCubit, ActiveLicenseState>(
            listenWhen:
                (previous, current) =>
                    current.verifyLicenseError != null &&
                    current.verifyLicenseError != previous.verifyLicenseError,
            listener: _errorListener,
          ),
          BlocListener<ActiveLicenseCubit, ActiveLicenseState>(
            listenWhen:
                (previous, current) =>
                    current.licenseInfo != null &&
                    current.licenseInfo != previous.licenseInfo,
            listener: _successListener,
          ),
        ],
        child: BlocBuilder<ActiveLicenseCubit, ActiveLicenseState>(
          builder: (context, state) {
            return Stack(
              children: [
                Scaffold(
                  appBar: const AppBarWidget(),
                  body: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: Spacing.md,
                        right: Spacing.md,
                        bottom: Spacing.lg,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(
                              context,
                            ).translate('Nhập mã kích hoạt'),
                            style: Theme.of(context).textTheme.displayMedium,
                          ),

                          const SizedBox(height: Spacing.lg),

                          TextFieldWidget(
                            controller: _controller,
                            onChanged:
                                context
                                    .read<ActiveLicenseCubit>()
                                    .changeLicenseCode,
                            hintText: 'XY12345ABC',
                            errorText: AppLocalizations.of(
                              context,
                            ).translate(state.licenseCode.displayError),
                            suffixIcon:
                                state.licenseCode.isNotValid &&
                                        state.licenseCode.value.isNotEmpty
                                    ? IconButton(
                                      onPressed: () => _clearCode(context),
                                      icon: const Icon(
                                        Icons.cancel,
                                        color: AppTheme.textGrayColor,
                                      ),
                                    )
                                    : null,
                            textCapitalization: TextCapitalization.characters,
                          ),

                          const SizedBox(height: Spacing.lg),

                          Center(
                            child: TextButton(
                              onPressed: () => _handleShowScanner(context),
                              child: Text(
                                AppLocalizations.of(
                                  context,
                                ).translate('Quét mã QR'),
                              ),
                            ),
                          ),

                          const Spacer(),

                          AppButton.primary(
                            text: AppLocalizations.of(
                              context,
                            ).translate('Hoàn thành'),
                            onPressed:
                                context
                                    .read<ActiveLicenseCubit>()
                                    .verifyLicenseCode,
                            disabled: state.licenseCode.isNotValid,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                state.isShowScanner
                    ? Stack(
                      children: [
                        MobileScanner(
                          controller: _cameraController,
                          onDetect:
                              (barcodes) => _handleQrCode(context, barcodes),

                          scanWindow: Rect.fromLTWH(
                            (MediaQuery.of(context).size.width - 250) / 2,
                            (MediaQuery.of(context).size.height - 250) / 2,
                            250,
                            250,
                          ),
                        ),
                        const ScannerOverlay(),
                        Positioned(
                          top: 50,
                          left: 20,
                          child: IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 40,
                            ),
                            onPressed:
                                () =>
                                    context
                                        .read<ActiveLicenseCubit>()
                                        .hideScanner(),
                          ),
                        ),
                      ],
                    )
                    : const SizedBox.shrink(),

                state.isLoading
                    ? const LoadingOverlay()
                    : const SizedBox.shrink(),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _handleShowScanner(BuildContext context) async {
    final isGranted = await PermissionUtil.checkCameraPermission(context);

    if (isGranted) {
      context.read<ActiveLicenseCubit>().showScanner();
    }
  }

  void _handleQrCode(BuildContext context, BarcodeCapture barcodes) {
    final code = barcodes.barcodes.firstOrNull?.displayValue ?? '';
    final isValid = context.read<ActiveLicenseCubit>().checkValidLicense(code);
    if (isValid) {
      _controller.text = code;
      context.read<ActiveLicenseCubit>().changeLicenseCode(code);
      context.read<ActiveLicenseCubit>().hideScanner();
      return;
    }

    _cameraController.stop();
    showCustomNoticeDialog(
      context: context,
      titleText: AppLocalizations.of(context).translate('Mã không hợp lệ'),
      messageText: AppLocalizations.of(
        context,
      ).translate('Vui lòng thực hiện lại thao tác'),
      imageAsset: 'assets/images/monkey_confused.png',
      primaryActionText: AppLocalizations.of(context).translate('Ok'),
      onPrimaryAction: () {
        context.pop();
        _cameraController.start();
      },
      isCloseable: false,
    );
  }

  void _clearCode(BuildContext context) {
    _controller.text = '';
    context.read<ActiveLicenseCubit>().changeLicenseCode('');
  }

  void _errorListener(BuildContext context, ActiveLicenseState state) {
    showCustomNoticeDialog(
      context: context,
      titleText: AppLocalizations.of(context).translate('Lỗi'),
      messageText: AppLocalizations.of(
        context,
      ).translate(state.verifyLicenseError ?? ''),
      imageAsset: 'assets/images/monkey_confused.png',
      primaryActionText: AppLocalizations.of(context).translate('Đóng'),
      isCloseable: false,
      onPrimaryAction: () {
        context.pop();
        context.read<ActiveLicenseCubit>().clearVerifyError();
      },
    );
  }

  void _successListener(BuildContext context, ActiveLicenseState state) {
    if (state.licenseInfo?.accountInfo != null) {
      context.push(AppRoutePaths.lastLoginInfo);
    } else {
      context.go(AppRoutePaths.activeLicenseInputPhone);
    }
  }
}

class ScannerOverlay extends StatelessWidget {
  final double borderRadius = 20;
  final double windowSize = 250;

  const ScannerOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;
        final left = (screenWidth - windowSize) / 2;
        final top = (screenHeight - windowSize) / 2;

        return Stack(
          children: [
            // Overlay đen với khung trong suốt ở giữa
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.6),
                BlendMode.srcOut,
              ),
              child: Stack(
                children: [
                  Container(
                    width: screenWidth,
                    height: screenHeight,
                    color: Colors.black.withOpacity(0.6),
                  ),
                  Positioned(
                    left: left,
                    top: top,
                    child: Container(
                      width: windowSize,
                      height: windowSize,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(borderRadius),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Viền trắng bo góc
            Positioned(
              left: left,
              top: top,
              child: Container(
                width: windowSize,
                height: windowSize,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
