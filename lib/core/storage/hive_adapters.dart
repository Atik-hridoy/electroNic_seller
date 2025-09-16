// Hive Type Adapters for complex data models
// This file contains Hive adapters for storing complex objects
// Uncomment and implement when Hive is added to the project

/*
import 'package:hive/hive.dart';

part 'hive_adapters.g.dart';

@HiveType(typeId: 0)
class UserModel {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String email;
  
  @HiveField(2)
  final String name;
  
  @HiveField(3)
  final String? phone;
  
  @HiveField(4)
  final String? profileImage;
  
  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    this.profileImage,
  });
}

@HiveType(typeId: 1)
class ProductModel {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String description;
  
  @HiveField(3)
  final double price;
  
  @HiveField(4)
  final String imageUrl;
  
  @HiveField(5)
  final String category;
  
  @HiveField(6)
  final int stock;
  
  @HiveField(7)
  final double? rating;
  
  @HiveField(8)
  final int reviewCount;
  
  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.stock,
    this.rating,
    this.reviewCount = 0,
  });
}

@HiveType(typeId: 2)
class CartItemModel {
  @HiveField(0)
  final String productId;
  
  @HiveField(1)
  final String productName;
  
  @HiveField(2)
  final double price;
  
  @HiveField(3)
  final int quantity;
  
  @HiveField(4)
  final String imageUrl;
  
  CartItemModel({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });
  
  double get totalPrice => price * quantity;
}

@HiveType(typeId: 3)
class OrderModel {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final DateTime orderDate;
  
  @HiveField(2)
  final double totalAmount;
  
  @HiveField(3)
  final String status;
  
  @HiveField(4)
  final List<CartItemModel> items;
  
  @HiveField(5)
  final String? trackingNumber;
  
  OrderModel({
    required this.id,
    required this.orderDate,
    required this.totalAmount,
    required this.status,
    required this.items,
    this.trackingNumber,
  });
}

@HiveType(typeId: 4)
class AddressModel {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String fullName;
  
  @HiveField(2)
  final String street;
  
  @HiveField(3)
  final String city;
  
  @HiveField(4)
  final String state;
  
  @HiveField(5)
  final String zipCode;
  
  @HiveField(6)
  final String country;
  
  @HiveField(7)
  final String phone;
  
  @HiveField(8)
  final bool isDefault;
  
  AddressModel({
    required this.id,
    required this.fullName,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    required this.phone,
    this.isDefault = false,
  });
}

// Register adapters when Hive is initialized
void registerHiveAdapters() {
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(ProductModelAdapter());
  Hive.registerAdapter(CartItemModelAdapter());
  Hive.registerAdapter(OrderModelAdapter());
  Hive.registerAdapter(AddressModelAdapter());
}
*/

// Placeholder for Hive adapters - will be implemented when Hive is added
class HiveAdapters {
  static void registerAdapters() {
    // This will be implemented when Hive is added to the project
    print('Hive adapters will be registered here when Hive is added');
  }
}
