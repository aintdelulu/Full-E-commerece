class AppUser {
  final String username;
  final String password;
  final bool isAdmin;

  String? imagePath;
  String? email;
  String? name;
  String? phone;
  String? bio;
  DateTime? dob;
  String? gender;
  List<double> weeklyOrders; // NEW: For order trends chart (Mon–Fri)

  AppUser({
    required this.username,
    required this.password,
    required this.isAdmin,
    this.imagePath,
    this.email,
    this.name,
    this.phone,
    this.bio,
    this.dob,
    this.gender,
    this.weeklyOrders = const [0, 0, 0, 0, 0], // Default 5-day week
  });

  /// Create AppUser from JSON (e.g. for persistence)
  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      username: json['username'],
      password: json['password'],
      isAdmin: json['isAdmin'] ?? false,
      imagePath: json['imagePath'],
      email: json['email'],
      name: json['name'],
      phone: json['phone'],
      bio: json['bio'],
      dob: json['dob'] != null ? DateTime.tryParse(json['dob']) : null,
      gender: json['gender'],
      weeklyOrders: (json['weeklyOrders'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [0, 0, 0, 0, 0],
    );
  }

  /// Convert AppUser to JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'isAdmin': isAdmin,
      'imagePath': imagePath,
      'email': email,
      'name': name,
      'phone': phone,
      'bio': bio,
      'dob': dob?.toIso8601String(),
      'gender': gender,
      'weeklyOrders': weeklyOrders,
    };
  }
}
