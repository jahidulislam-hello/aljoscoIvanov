class UserModel {
  final String userId;
  final String name;
  final String email;
  final String phoneNumber;
  final String? profileImageUrl;
  final bool isPremium;

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.profileImageUrl,
    this.isPremium = false,
  });
}