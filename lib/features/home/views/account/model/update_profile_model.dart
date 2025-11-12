class UpdateProfileModel {
  final String firstName;
  final String lastName;
  final String gender;
  final String address;
  final String phone;
  final String shopName;
  final int shippingCost;
  final String? profileImage;

  UpdateProfileModel({
    required this.firstName,
    required this.lastName,
    this.gender = '',
    this.address = '',
    required this.phone,
    this.shopName = '',
    this.shippingCost = 0,
    this.profileImage,
  });

  // Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'address': address,
      'phone': phone,
      'shopName': shopName,
      'shippingCost': shippingCost,
      'profileImage': profileImage,
    };
  }

  // Create model from JSON
  factory UpdateProfileModel.fromJson(Map<String, dynamic> json) {
    return UpdateProfileModel(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      gender: json['gender'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      shopName: json['shopName'] ?? '',
      shippingCost: json['shippingCost'] is String 
          ? int.tryParse(json['shippingCost']) ?? 0
          : json['shippingCost'] ?? 0,
      profileImage: json['profileImage'],
    );
  }

  // Create a copy of the model with updated fields
  UpdateProfileModel copyWith({
    String? firstName,
    String? lastName,
    String? gender,
    String? address,
    String? phone,
    String? shopName,
    int? shippingCost,
    String? profileImage,
  }) {
    return UpdateProfileModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      shopName: shopName ?? this.shopName,
      shippingCost: shippingCost ?? this.shippingCost,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}