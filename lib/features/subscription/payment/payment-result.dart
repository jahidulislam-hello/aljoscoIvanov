/// Payment result class to handle different payment outcomes
class PaymentResult {
  final bool isSuccess;
  final String? message;
  final Map<String, dynamic>? paymentData;
  final String? errorCode;

  PaymentResult._({
    required this.isSuccess,
    this.message,
    this.paymentData,
    this.errorCode,
  });

  factory PaymentResult.success({
    String? message,
    Map<String, dynamic>? paymentData,
  }) {
    return PaymentResult._(
      isSuccess: true,
      message: message ?? 'Payment completed successfully!',
      paymentData: paymentData,
    );
  }

  factory PaymentResult.failure({required String message, String? errorCode}) {
    return PaymentResult._(
      isSuccess: false,
      message: message,
      errorCode: errorCode,
    );
  }
}