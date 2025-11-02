import 'enums.dart';

class Request {
  final String id;
  final String userId;
  final String title;
  final String description;
  final ServiceCategory category;
  final String urgency;
  final double? budget;
  final PricingType pricingType;
  final String contact;
  final String city;
  final String state;
  final bool isVoluntary;
  final DateTime createdAt;
  final DateTime updatedAt;

  Request({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.category,
    required this.urgency,
    this.budget,
    required this.pricingType,
    required this.contact,
    required this.city,
    required this.state,
    this.isVoluntary = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: ServiceCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => ServiceCategory.outros,
      ),
      urgency: json['urgency'] as String,
      budget: json['budget'] != null ? (json['budget'] as num).toDouble() : null,
      pricingType: PricingType.values.firstWhere(
        (e) => e.name == json['pricing_type'],
        orElse: () => PricingType.aCombinar,
      ),
      contact: json['contact'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      isVoluntary: json['is_voluntary'] ?? false,
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
      'urgency': urgency,
      'budget': budget,
      'pricing_type': pricingType.name,
      'contact': contact,
      'city': city,
      'state': state,
      'is_voluntary': isVoluntary,
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

  Request copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    ServiceCategory? category,
    String? urgency,
    double? budget,
    PricingType? pricingType,
    String? contact,
    String? city,
    String? state,
    bool? isVoluntary,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Request(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      urgency: urgency ?? this.urgency,
      budget: budget ?? this.budget,
      pricingType: pricingType ?? this.pricingType,
      contact: contact ?? this.contact,
      city: city ?? this.city,
      state: state ?? this.state,
      isVoluntary: isVoluntary ?? this.isVoluntary,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
