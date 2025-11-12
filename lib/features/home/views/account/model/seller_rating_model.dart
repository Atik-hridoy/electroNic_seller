class SellerRatingModel {
  final double averageRating;
  final int totalReviews;
  final RatingBreakdown ratingBreakdown;
  final RatingPercentages ratingPercentages;

  SellerRatingModel({
    required this.averageRating,
    required this.totalReviews,
    required this.ratingBreakdown,
    required this.ratingPercentages,
  });

  factory SellerRatingModel.fromJson(Map<String, dynamic> json) {
    return SellerRatingModel(
      averageRating: _parseDouble(json['averageRating']),
      totalReviews: json['totalReviews'] ?? 0,
      ratingBreakdown: RatingBreakdown.fromJson(json['ratingBreakdown'] ?? {}),
      ratingPercentages: RatingPercentages.fromJson(json['ratingPercentages'] ?? {}),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'averageRating': averageRating,
      'totalReviews': totalReviews,
      'ratingBreakdown': ratingBreakdown.toJson(),
      'ratingPercentages': ratingPercentages.toJson(),
    };
  }
}

class RatingBreakdown {
  final int star1;
  final int star2;
  final int star3;
  final int star4;
  final int star5;

  RatingBreakdown({
    required this.star1,
    required this.star2,
    required this.star3,
    required this.star4,
    required this.star5,
  });

  factory RatingBreakdown.fromJson(Map<String, dynamic> json) {
    return RatingBreakdown(
      star1: json['1'] ?? 0,
      star2: json['2'] ?? 0,
      star3: json['3'] ?? 0,
      star4: json['4'] ?? 0,
      star5: json['5'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '1': star1,
      '2': star2,
      '3': star3,
      '4': star4,
      '5': star5,
    };
  }
}

class RatingPercentages {
  final int star1Percent;
  final int star2Percent;
  final int star3Percent;
  final int star4Percent;
  final int star5Percent;

  RatingPercentages({
    required this.star1Percent,
    required this.star2Percent,
    required this.star3Percent,
    required this.star4Percent,
    required this.star5Percent,
  });

  factory RatingPercentages.fromJson(Map<String, dynamic> json) {
    return RatingPercentages(
      star1Percent: json['1'] ?? 0,
      star2Percent: json['2'] ?? 0,
      star3Percent: json['3'] ?? 0,
      star4Percent: json['4'] ?? 0,
      star5Percent: json['5'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '1': star1Percent,
      '2': star2Percent,
      '3': star3Percent,
      '4': star4Percent,
      '5': star5Percent,
    };
  }
}
