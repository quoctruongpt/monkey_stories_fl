import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:monkey_stories/core/constants/constants.dart';
import 'package:monkey_stories/core/routes/routes.dart';
import 'package:monkey_stories/domain/usecases/tracking/setting/ms_parent_setting_detail.dart';
import 'package:monkey_stories/data/models/setting/setting_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkey_stories/presentation/bloc/account/user/user_cubit.dart';

import 'package:monkey_stories/presentation/bloc/app/app_cubit.dart';
import 'package:monkey_stories/presentation/widgets/dialogs/delete_data_dialog.dart';
import 'package:monkey_stories/presentation/widgets/dialogs/logout_dialog.dart';

final List<Map<String, dynamic>> settingsData = [
  {
    'title': 'app.setting.parent_info',
    'items': [
      SettingItem(
        icon: 'assets/icons/svg/person.svg',
        label: 'app.user_info.title',
        route: AppRouteNames.userInfo,
        clickType: ClickType.parentInfo,
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
        clickType: ClickType.userProfile,
      ),
      SettingItem(
        icon: 'assets/icons/svg/unlock.svg',
        label: 'app.setting.license_key',
        onTap: (BuildContext context) {
          context.push(
            AppRoutePaths.inputLicense,
            extra: {'source': 'parents'},
          );
        },
        clickType: ClickType.licenseKey,
        isVisibleGetter: (BuildContext context) async {
          final isHide = context.read<AppCubit>().state.isHideSensitiveFeatures;
          return !isHide;
        },
      ),
      SettingItem(
        icon: 'assets/icons/svg/password.svg',
        label: 'app.change_password.title',
        route: AppRouteNames.changePassword,
        isVisibleGetter: (BuildContext context) async {
          final user = context.read<UserCubit>().state.user;
          return user?.loginType != LoginType.skip;
        },
        clickType: ClickType.changePassword,
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
        clickType: ClickType.generalSettings,
      ),
      SettingItem(
        icon: 'assets/icons/svg/trash.svg',
        label: 'app.setting.delete_data',
        clickType: ClickType.deleteData,
        onTap: (BuildContext context) {
          showDeleteDataDialog(context);
        },
      ),
      SettingItem(
        icon: 'assets/icons/svg/alarm-check.svg',
        label: 'app.schedule_manager.title',
        route: AppRouteNames.scheduleManager,
        clickType: ClickType.reminder,
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
        clickType: ClickType.aboutMonkey,
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
        clickType: ClickType.termsOfUse,
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
        clickType: ClickType.privacyPolicy,
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
        clickType: ClickType.frequentlyAskedQuestions,
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
        clickType: ClickType.contactMonkey,
      ),
      SettingItem(
        icon: 'assets/icons/svg/trash.svg',
        label: 'app.setting.delete_account',
        onTap: (BuildContext context) {
          final url = dotenv.env['DELETE_ACCOUNT_URL'] ?? '';
          if (url.isNotEmpty) {
            context.pushNamed(
              AppRouteNames.webView,
              queryParameters: {
                'title': 'app.setting.delete_account',
                'url': url,
              },
            );
          }
        },
        clickType: ClickType.deleteAccount,
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
        clickType: ClickType.signOut,
      ),
    ],
  },
];

final Map<String, String> aboutMonkey = {
  'vi': 'https://monkey.edu.vn/gioi-thieu',
  'th': 'https://www.monkeyenglish.net/th/about-us',
  'other': 'https://www.monkeyenglish.net/about-monkey',
};

final Map<String, String> termsOfUseLinks = {
  'vi': 'https://monkey.edu.vn/dieu-khoan-su-dung',
  'th': 'https://www.monkeyenglish.net/th/terms-of-use',
  'other': 'https://www.monkeyenglish.net/terms-of-use',
};

final Map<String, String> privacyPolicyLinks = {
  'vi': 'https://monkey.edu.vn/chinh-sach-bao-mat',
  'th': 'https://www.monkeyenglish.net/th/policy',
  'other': 'https://www.monkeyenglish.net/policy',
};

final Map<String, String> frequentlyAskedQuestionsLinks = {
  'vi': 'https://monkey.edu.vn/ho-tro-khach-hang',
  'th': 'https://www.monkeyenglish.net/th/customer-support.html',
  'other': 'https://www.monkeyenglish.net/customer-support',
};

final Map<String, String> contactMonkeyLinks = {
  'vi': 'https://monkey.edu.vn/lien-he',
  'th': 'https://www.monkeyenglish.net/th/contact-us',
  'other': 'https://www.monkeyenglish.net/contact',
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

final List<String> folderPaths = [];
