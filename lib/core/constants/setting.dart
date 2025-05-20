import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/routes/routes.dart';
import 'package:monkey_stories/data/models/setting/setting_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkey_stories/presentation/bloc/account/user/user_cubit.dart';

import 'package:monkey_stories/presentation/bloc/app/app_cubit.dart';
import 'package:monkey_stories/presentation/widgets/dialogs/logout_dialog.dart';

final List<Map<String, dynamic>> settingsData = [
  {
    'title': 'app.setting.parent_info',
    'items': [
      SettingItem(
        icon: 'assets/icons/svg/person.svg',
        label: 'app.user_info.title',
        route: AppRouteNames.userInfo,
      ),
      SettingItem(
        icon: 'assets/icons/svg/mobile.svg',
        label: 'app.setting.device_id',
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
        label: 'app.setting.user_id',
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
    'title': 'app.setting.student_management',
    'items': [
      SettingItem(
        icon: 'assets/icons/svg/student.svg',
        label: 'app.setting.student_profile',
        route: AppRouteNames.listProfileSetting,
      ),
      SettingItem(
        icon: 'assets/icons/svg/unlock.svg',
        label: 'app.setting.license_key',
        route: AppRouteNames.inputLicense,
      ),
      SettingItem(
        icon: 'assets/icons/svg/password.svg',
        label: 'app.change_password.title',
        route: AppRouteNames.changePassword,
        isVisibleGetter: (BuildContext context) async {
          final user = context.read<UserCubit>().state.user;
          return user?.loginType != LoginType.skip;
        },
      ),
    ],
  },
  {
    'title': 'app.setting.setting',
    'items': [
      SettingItem(
        icon: 'assets/icons/svg/setting_orange.svg',
        label: 'app.setting.general',
        route: AppRouteNames.generalSetting,
      ),
      SettingItem(
        icon: 'assets/icons/svg/alarm-check.svg',
        label: 'app.schedule_manager.title',
        route: AppRouteNames.scheduleManager,
      ),
    ],
  },
  {
    'title': 'app.setting.support',
    'items': [
      SettingItem(
        icon: 'assets/icons/svg/danger_circle.svg',
        label: 'app.setting.about_monkey',
        onTap: (BuildContext context) {
          final url = getLocalizedLink(context, aboutMonkey);
          if (url.isNotEmpty) {
            context.pushNamed(
              AppRouteNames.webView,
              queryParameters: {
                'title': 'app.setting.about_monkey',
                'url': url,
              },
            );
          }
        },
      ),
      SettingItem(
        icon: 'assets/icons/svg/paper.svg',
        label: 'app.setting.terms_of_use',
        onTap: (BuildContext context) {
          final url = getLocalizedLink(context, termsOfUseLinks);
          if (url.isNotEmpty) {
            context.pushNamed(
              AppRouteNames.webView,
              queryParameters: {
                'title': 'app.setting.terms_of_use',
                'url': url,
              },
            );
          }
        },
      ),
      SettingItem(
        icon: 'assets/icons/svg/shield.svg',
        label: 'app.setting.privacy_policy',
        onTap: (BuildContext context) {
          final url = getLocalizedLink(context, privacyPolicyLinks);
          if (url.isNotEmpty) {
            context.pushNamed(
              AppRouteNames.webView,
              queryParameters: {
                'title': 'app.setting.privacy_policy',
                'url': url,
              },
            );
          }
        },
      ),
      SettingItem(
        icon: 'assets/icons/svg/chat.svg',
        label: 'app.setting.frequently_asked_questions',
        onTap: (BuildContext context) {
          final url = getLocalizedLink(context, frequentlyAskedQuestionsLinks);
          if (url.isNotEmpty) {
            context.pushNamed(
              AppRouteNames.webView,
              queryParameters: {
                'title': 'app.setting.frequently_asked_questions',
                'url': url,
              },
            );
          }
        },
      ),
      SettingItem(
        icon: 'assets/icons/svg/calling.svg',
        label: 'app.setting.contact_monkey',
        onTap: (BuildContext context) {
          final url = getLocalizedLink(context, contactMonkeyLinks);
          if (url.isNotEmpty) {
            context.pushNamed(
              AppRouteNames.webView,
              queryParameters: {
                'title': 'app.setting.contact_monkey',
                'url': url,
              },
            );
          }
        },
      ),
    ],
  },
  {
    'title': 'app.setting.logout',
    'items': [
      SettingItem(
        icon: 'assets/icons/svg/logout.svg',
        label: 'app.setting.logout_label',
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
