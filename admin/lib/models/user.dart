// models/user.dart
class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final bool isAdmin;
  final String street;
  final String apartment;
  final String zip;
  final String city;
  final String country;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.isAdmin,
    required this.street,
    required this.apartment,
    required this.zip,
    required this.city,
    required this.country,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      isAdmin: json['isAdmin'] ?? false,
      street: json['street'] ?? '',
      apartment: json['apartment'] ?? '',
      zip: json['zip'] ?? '',
      city: json['city'] ?? '',
      country: json['country'] ?? '',
    );
  }
}
