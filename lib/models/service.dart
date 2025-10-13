import 'enums.dart';

class Service {
  final String id;
  final String userId;
  final String title;
  final String description;
  final ServiceCategory category;
  final String availability;
  final double? value;
  final PricingType pricingType;
  final String contact;
  final String city;
  final String state;
  final DateTime createdAt;
  final DateTime updatedAt;

  Service({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.category,
    required this.availability,
    this.value,
    required this.pricingType,
    required this.contact,
    required this.city,
    required this.state,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: ServiceCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => ServiceCategory.outros,
      ),
      availability: json['availability'] as String,
      value: json['value'] != null ? (json['value'] as num).toDouble() : null,
      pricingType: PricingType.values.firstWhere(
        (e) => e.name == json['pricing_type'],
        orElse: () => PricingType.aCombinar,
      ),
      contact: json['contact'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson({bool forInsert = false}) {
    final Map<String, dynamic> json = {
      'user_id': userId,
      'title': title,
      'description': description,
      'category': category.name,
      'availability': availability,
      'value': value,
      'pricing_type': pricingType.name,
      'contact': contact,
      'city': city,
      'state': state,
    };

    // Não incluir id, created_at e updated_at se for insert (deixar o banco gerar)
    if (!forInsert || id.isNotEmpty) {
      json['id'] = id;
    }
    
    if (!forInsert) {
      json['created_at'] = createdAt.toIso8601String();
      json['updated_at'] = updatedAt.toIso8601String();
    }

    return json;
  }

  Service copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    ServiceCategory? category,
    String? availability,
    double? value,
    PricingType? pricingType,
    String? contact,
    String? city,
    String? state,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Service(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      availability: availability ?? this.availability,
      value: value ?? this.value,
      pricingType: pricingType ?? this.pricingType,
      contact: contact ?? this.contact,
      city: city ?? this.city,
      state: state ?? this.state,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
