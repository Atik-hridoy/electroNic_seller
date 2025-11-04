class UpdateProfileModel {
  final String firstName;
  final String lastName;
  final String gender;
  final String address;
  final String phone;
  final String? profileImage;

  UpdateProfileModel({
    required this.firstName,
    required this.lastName,
    this.gender = '',
    this.address = '',
    required this.phone,
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
    String? profileImage,
  }) {
    return UpdateProfileModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}