// import 'dart:convert';

// import 'package:flutter_inapp_purchase/modules.dart';
// import 'package:monkey_stories/core/constants/constants.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// abstract class PurchasedLocalDataSource {
//   Future<void> cachePurchasedLatest(PurchasedItem purchased);
//   Future<PurchasedItem> getPurchasedLatest();
// }

// class PurchasedLocalDataSourceImpl extends PurchasedLocalDataSource {
//   final SharedPreferences sharedPreferences;

//   PurchasedLocalDataSourceImpl({required this.sharedPreferences});

//   @override
//   Future<void> cachePurchasedLatest(PurchasedItem purchased) async {
//     await sharedPreferences.setString(
//       SharedPrefKeys.purchasedLatest,
//       jsonEncode(purchased),
//     );
//   }

//   @override
//   Future<PurchasedItem> getPurchasedLatest() async {
//     return await sharedPreferences.getString(_purchasedLatestKey);
//   }
// }
