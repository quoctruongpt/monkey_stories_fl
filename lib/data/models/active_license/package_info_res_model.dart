import 'package:monkey_stories/domain/entities/active_license/package_info.dart';

class PackageInfoResModel {
  final List<dynamic> courseId;
  final String productName;
  final int appId;
  final String productId;
  final int price;
  final String currency;
  final String courseName;

  PackageInfoResModel({
    required this.courseId,
    required this.productName,
    required this.appId,
    required this.productId,
    required this.price,
    required this.currency,
    required this.courseName,
  });

  factory PackageInfoResModel.fromJson(Map<String, dynamic> json) {
    return PackageInfoResModel(
      courseId: json['course_id'],
      productName: json['product_name'],
      appId: json['app_id'],
      productId: json['product_id'],
      price: json['price'],
      currency: json['currency'],
      courseName: json['course_name'],
    );
  }

  PackageInfoEntity toEntity() {
    return PackageInfoEntity(
      appId: appId,
      productName: productName,
      courseName: courseName,
      courseId: courseId,
    );
  }
}
