import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
        route: AppRouteNames.userInfo,
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
        showArrow: false,
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
        showArrow: false,
      ),
    ],
  },
  {
    'title': 'QUẢN LÝ NGƯỜI HỌC',
    'items': [
      SettingItem(
        icon: 'assets/icons/svg/student.svg',
        label: 'Hồ sơ học tập của con',
        route: AppRouteNames.listProfileSetting,
      ),
      SettingItem(
        icon: 'assets/icons/svg/unlock.svg',
        label: 'Nhập mã kích hoạt',
        route: AppRouteNames.inputLicense,
      ),
      SettingItem(
        icon: 'assets/icons/svg/password.svg',
        label: 'Thay đổi mật khẩu',
        route: AppRouteNames.changePassword,
        isVisibleGetter: (BuildContext context) async {
          final user = context.read<UserCubit>().state.user;
          return user?.loginType != LoginType.skip;
        },
      ),
    ],
  },
  {
    'title': 'CÀI ĐẶT',
    'items': [
      SettingItem(
        icon: 'assets/icons/svg/setting_orange.svg',
        label: 'Cài đặt chung',
        route: AppRouteNames.generalSetting,
      ),
      SettingItem(
        icon: 'assets/icons/svg/alarm-check.svg',
        label: 'Đặt lịch học',
        route: AppRouteNames.home,
      ),
    ],
  },
  {
    'title': 'HỖ TRỢ',
    'items': [
      SettingItem(
        icon: 'assets/icons/svg/danger_circle.svg',
        label: 'Về Monkey',
        onTap: (BuildContext context) {
          final url = getLocalizedLink(context, aboutMonkey);
          if (url.isNotEmpty) {
            context.pushNamed(
              AppRouteNames.webView,
              queryParameters: {'title': 'Về Monkey', 'url': url},
            );
          }
        },
      ),
      SettingItem(
        icon: 'assets/icons/svg/paper.svg',
        label: 'Điều khoản sử dụng',
        onTap: (BuildContext context) {
          final url = getLocalizedLink(context, termsOfUseLinks);
          if (url.isNotEmpty) {
            context.pushNamed(
              AppRouteNames.webView,
              queryParameters: {'title': 'Điều khoản sử dụng', 'url': url},
            );
          }
        },
      ),
      SettingItem(
        icon: 'assets/icons/svg/shield.svg',
        label: 'Chính sách bảo mật',
        onTap: (BuildContext context) {
          final url = getLocalizedLink(context, privacyPolicyLinks);
          if (url.isNotEmpty) {
            context.pushNamed(
              AppRouteNames.webView,
              queryParameters: {'title': 'Chính sách bảo mật', 'url': url},
            );
          }
        },
      ),
      SettingItem(
        icon: 'assets/icons/svg/chat.svg',
        label: 'Câu hỏi thường gặp',
        onTap: (BuildContext context) {
          final url = getLocalizedLink(context, frequentlyAskedQuestionsLinks);
          if (url.isNotEmpty) {
            context.pushNamed(
              AppRouteNames.webView,
              queryParameters: {'title': 'Câu hỏi thường gặp', 'url': url},
            );
          }
        },
      ),
      SettingItem(
        icon: 'assets/icons/svg/calling.svg',
        label: 'Liên hệ Monkey',
        onTap: (BuildContext context) {
          final url = getLocalizedLink(context, contactMonkeyLinks);
          if (url.isNotEmpty) {
            context.pushNamed(
              AppRouteNames.webView,
              queryParameters: {'title': 'Liên hệ Monkey', 'url': url},
            );
          }
        },
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
        showArrow: false,
      ),
    ],
  },
];

final Map<String, String> aboutMonkey = {
  'vi': 'https://monkey.edu.vn/gioi-thieu',
  'th': 'https://www.monkeyenglish.net/th/',
  'other': 'https://www.monkeyenglish.net/en/about-monkey',
};

final Map<String, String> termsOfUseLinks = {
  'vi': 'https://monkey.edu.vn/dieu-khoan-su-dung',
  'th':
      'https://www.monkeyenglish.net/th/tips-for-parents/terms-of-service-th.html',
  'other': 'https://www.monkeyenglish.net/en/terms-of-use',
};

final Map<String, String> privacyPolicyLinks = {
  'vi': 'https://monkey.edu.vn/chinh-sach-bao-mat',
  'th':
      'https://www.monkeyenglish.net/th/tips-for-parents/privacy-policy-th.html',
  'other': 'https://www.monkeyenglish.net/en/policy',
};

final Map<String, String> frequentlyAskedQuestionsLinks = {
  'vi': 'https://monkey.edu.vn/ho-tro-khach-hang',
  'th': 'https://www.monkeyenglish.net/th/customer-support.html',
  'other': 'https://www.monkeyenglish.net/en/customer-support',
};

final Map<String, String> contactMonkeyLinks = {
  'vi': 'https://monkey.edu.vn/lien-he',
  'th': 'https://www.monkeyenglish.net/th/contact-us',
  'other': 'https://www.monkeyenglish.net/en/contact',
};

String getLocalizedLink(BuildContext context, Map<String, String> linkMap) {
  final languageCode = context.read<AppCubit>().state.languageCode;
  if (linkMap.containsKey(languageCode)) {
    return linkMap[languageCode]!;
  } else if (linkMap.containsKey('other')) {
    return linkMap['other']!;
  } else if (linkMap.isNotEmpty) {
    return linkMap.values.first;
  }
  return ''; // Return an empty string or handle error as needed
}
