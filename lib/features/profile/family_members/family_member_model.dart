class FamilyMemberModel {
  final String? id;
  final String? name;
  final String? email;
  final String? image;
  final String? role;

  FamilyMemberModel({
    this.id,
    this.name,
    this.email,
    this.image,
    this.role,
  });

  factory FamilyMemberModel.fromJson(Map<String, dynamic> json) {
    return FamilyMemberModel(
      id: json['_id'] as String?,
      name: json['fullName'] as String?,
      email: json['email'] as String?,
      image: json['profileImage'] as String?,
      role: json['role'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullName': name,
      'email': email,
      'profileImage': image,
      'role': role,
    };
  }
}
