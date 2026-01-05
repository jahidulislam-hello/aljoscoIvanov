class UserModel {
  final String userId;
  final String name;
  final String email;
  final String phoneNumber;
  final String? profileImageUrl;
  final bool isPremium;
  final String planType; // guest, premium, trial
  final String subscriptionStatus; // active, inactive

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.profileImageUrl,
    this.isPremium = false,
    this.planType = 'guest',
    this.subscriptionStatus = 'inactive',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final planType = json['planType'] ?? 'guest';
    final subscriptionStatus = json['subscriptionStatus'] ?? 'inactive';

    return UserModel(
      userId: json['slug_id'] ?? '',
      name: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber']?.toString() ?? '',
      profileImageUrl: json['profileImage'],
      planType: planType,
      subscriptionStatus: subscriptionStatus,
      isPremium: (planType == 'premium' || planType == 'trial') && subscriptionStatus == 'active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slug_id': userId,
      'fullName': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'profileImage': profileImageUrl,
      'planType': planType,
      'subscriptionStatus': subscriptionStatus,
    };
  }

  String getPlanDisplayName() {
    if (planType == 'trial') {
      return 'Trial';
    } else if (planType == 'premium') {
      return 'Premium';
    }
    return 'Guest';
  }

  bool get isTrialUser => planType == 'trial' && subscriptionStatus == 'active';
  bool get isPremiumUser => planType == 'premium' && subscriptionStatus == 'active';
  bool get isGuestUser => planType == 'guest';
}