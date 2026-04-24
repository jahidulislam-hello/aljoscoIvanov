// /// Exception class for Stripe payment errors
// class StripePaymentException implements Exception {
//   final String message;
//   final String? errorCode;
//   final dynamic originalError;
//
//   StripePaymentException(this.message, {this.errorCode, this.originalError});
//
//   @override
//   String toString() => 'StripePaymentException: $message';
// }