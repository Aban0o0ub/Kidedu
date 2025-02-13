class CourseModel {
  String courseName;
  String? instructor;
  String? level;
  String availability;
  num? offer;
  String category;
  String description;
  num price;
  num? priceAfterDiscount;
  DateTime? startDate;
  DateTime? endDate;
  String? courseImage;
  String firstSection;
  num? ratingAvg;
  num? ratingQuantity;
  num? ratingSum;
  List<String>? allSections;

  CourseModel(
      {required this.courseName,
      this.instructor,
      this.level,
      required this.availability,
      this.offer,
      required this.category,
      required this.description,
      required this.price,
      this.priceAfterDiscount,
      this.startDate,
      this.endDate,
      this.courseImage,
      required this.firstSection,
      this.ratingAvg,
      this.ratingQuantity,
      this.ratingSum,
      this.allSections});

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      courseName: json['course_name'],
      instructor: json['instructor'],
      level: json['level'],
      availability: json['availability'],
      offer: json['offer'],
      category: json['category'],
      description: json['description'],
      price: json['price'],
      priceAfterDiscount: json['price_after_discount'],
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'])
          : null,
      endDate:
          json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      courseImage: json['course_image'],
      firstSection: json['first_section'],
      ratingAvg: json['rating_Avarage'] != null
          ? json['rating_Avarage'].toDouble()
          : null,
      ratingQuantity: json['rating_quantity'] != null
          ? json['rating_quantity'].toDouble()
          : null,
      ratingSum:
          json['rating_sum'] != null ? json['rating_sum'].toDouble() : null,
      allSections: json['all_sections'] != null
          ? List<String>.from(json['all_sections'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "course_name": courseName,
      "instructor": instructor,
      "level": level,
      "availability": availability,
      "offer": offer,
      "category": category,
      "description": description,
      "price": price,
      "price_after_discount": priceAfterDiscount,
      "start_date": startDate?.toIso8601String(),
      "end_date": endDate?.toIso8601String(),
      "course_image": courseImage,
      "first_section": firstSection,
      "rating_Avarage": ratingAvg,
      "rating_quantity": ratingQuantity,
      "rating_sum": ratingSum,
      "all_sections": allSections,
    };
  }
}
