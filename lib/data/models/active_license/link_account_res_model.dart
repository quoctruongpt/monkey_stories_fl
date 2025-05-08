class LinkAccountResModel {
  final int userId;

  LinkAccountResModel({required this.userId});

  factory LinkAccountResModel.fromJson(Map<String, dynamic> json) {
    return LinkAccountResModel(userId: json['user_id']);
  }
}
