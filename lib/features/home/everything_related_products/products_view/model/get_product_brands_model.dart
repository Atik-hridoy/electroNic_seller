class BrandModel {
  final String id;
  final String name;
  final String image;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BrandModel({
    required this.id,
    required this.name,
    required this.image,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  // Convert JSON to BrandModel
  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  // Convert BrandModel to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'image': image,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Create a copy of the model with some fields updated
  BrandModel copyWith({
    String? id,
    String? name,
    String? image,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BrandModel(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'BrandModel(id: $id, name: $name, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BrandModel &&
        other.id == id &&
        other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}

// Extension for RxList<BrandModel>
extension BrandListExtension on List<BrandModel> {
  // Find brand by ID
  BrandModel? findById(String id) {
    try {
      return firstWhere((brand) => brand.id == id);
    } catch (e) {
      return null;
    }
  }

  // Find brand by name (case insensitive)
  BrandModel? findByName(String name) {
    try {
      return firstWhere(
        (brand) => brand.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  // Get active brands
  List<BrandModel> get activeBrands =>
      where((brand) => brand.isActive).toList();

  // Sort brands by name
  void sortByName({bool ascending = true}) {
    if (ascending) {
      sort((a, b) => a.name.compareTo(b.name));
    } else {
      sort((a, b) => b.name.compareTo(a.name));
    }
  }
}