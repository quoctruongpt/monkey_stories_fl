import 'package:flutter/material.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/routes/routes.dart';
import 'package:monkey_stories/data/models/setting/setting_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkey_stories/presentation/bloc/account/user/user_cubit.dart';

import 'package:monkey_stories/presentation/bloc/app/app_cubit.dart';
import 'package:monkey_stories/presentation/widgets/logout_dialog.dart';

final List<Map<String, dynamic>> settingsData = [
  {
    'title': 'THÔNG TIN PHỤ HUYNH',
    'items': [
      SettingItem(
        icon: 'assets/icons/svg/person.svg',
        label: 'Thông tin ba mẹ',
        route: AppRoutePaths.userInfo,
      ),
      SettingItem(
        icon: 'assets/icons/svg/mobile.svg',
        label: 'ID thiết bị',
        valueGetter: () async {
          final context = navigatorKey.currentContext;
          if (context != null) {
            return context.read<AppCubit>().state.deviceId;
          }
          return 'N/A';
        },
      ),
      SettingItem(
        icon: 'assets/icons/svg/user-circle.svg',
        label: 'ID người dùng',
        valueGetter: () async {
          final context = navigatorKey.currentContext;
          if (context != null) {
            return context.read<UserCubit>().state.user?.userId.toString();
          }
          return 'N/A';
        },
      ),
    ],
  },
  {
    'title': 'QUẢN LÝ NGƯỜI HỌC',
    'items': [
      SettingItem(
        icon: 'assets/icons/svg/student.svg',
        label: 'Hồ sơ học tập của con',
        route: AppRoutePaths.home,
      ),
      SettingItem(
        icon: 'assets/icons/svg/unlock.svg',
        label: 'Nhập mã kích hoạt',
        route: AppRoutePaths.home,
      ),
      SettingItem(
        icon: 'assets/icons/svg/password.svg',
        label: 'Thay đổi mật khẩu',
        route: AppRoutePaths.home,
      ),
    ],
  },
  {
    'title': 'CÀI ĐẶT',
    'items': [
      SettingItem(
        icon: 'assets/icons/svg/setting_orange.svg',
        label: 'Cài đặt chung',
        route: AppRoutePaths.home,
      ),
      SettingItem(
        icon: 'assets/icons/svg/alarm-check.svg',
        label: 'Đặt lịch học',
        route: AppRoutePaths.home,
      ),
    ],
  },
  {
    'title': 'HỖ TRỢ',
    'items': [
      SettingItem(
        icon: 'assets/icons/svg/danger_circle.svg',
        label: 'Về Monkey',
        route: AppRoutePaths.home,
      ),
      SettingItem(
        icon: 'assets/icons/svg/paper.svg',
        label: 'Điều khoản sử dụng',
        route: AppRoutePaths.home,
      ),
      SettingItem(
        icon: 'assets/icons/svg/shield.svg',
        label: 'Chính sách bảo mật',
        route: AppRoutePaths.home,
      ),
      SettingItem(
        icon: 'assets/icons/svg/chat.svg',
        label: 'Câu hỏi thường gặp',
        route: AppRoutePaths.home,
      ),
      SettingItem(
        icon: 'assets/icons/svg/calling.svg',
        label: 'Liên hệ Monkey',
        route: AppRoutePaths.home,
      ),
    ],
  },
  {
    'title': 'ĐĂNG XUẤT',
    'items': [
      SettingItem(
        icon: 'assets/icons/svg/logout.svg',
        label: 'Đăng xuất',
        onTap: (BuildContext context) {
          showLogoutDialog(context);
        },
      ),
    ],
  },
];
