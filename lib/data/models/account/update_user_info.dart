class UpdateUserInfoParams {
  final String? name;
  final String? email;
  final String? countryCode;
  final String? phone;
  final String? phoneString;

  UpdateUserInfoParams({
    this.name,
    this.email,
    this.countryCode,
    this.phone,
    this.phoneString,
  });

  Map<String, dynamic> toJson() => {
    'user_name': name,
    'email': email,
    'phoneData': {'countryCode': countryCode, 'phone': phone},
    'phone': phoneString,
  };
}
