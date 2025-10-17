class UpdateProfileModel {
  final String firstName;
  final String lastName;
  final String gender;
  final String address;
  final String addressCategory;

  UpdateProfileModel({
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.address,
    required this.addressCategory,
  });

  /// Convert to JSON for sending via API
  Map<String, dynamic> toJson() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "gender": gender,
      "address": address,
      "addressCategory": addressCategory,
    };
  }

  /// Parse from JSON (optional, for handling API response)
  factory UpdateProfileModel.fromJson(Map<String, dynamic> json) {
    return UpdateProfileModel(
      firstName: json["firstName"] ?? "",
      lastName: json["lastName"] ?? "",
      gender: json["gender"] ?? "",
      address: json["address"] ?? "",
      addressCategory: json["addressCategory"] ?? "",
    );
  }
}
