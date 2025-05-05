class ContactLocalModel {
  final String? name;
  final String phone;
  final String countryCode;

  ContactLocalModel({
    this.name,
    required this.phone,
    required this.countryCode,
  });

  factory ContactLocalModel.fromJson(Map<String, dynamic> json) {
    return ContactLocalModel(
      name: json['name'],
      phone: json['phone'],
      countryCode: json['countryCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'phone': phone, 'countryCode': countryCode};
  }
}
