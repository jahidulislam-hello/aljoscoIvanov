import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:freshbite/core/utils/shared_preference_helper.dart';
import 'package:freshbite/routes/routes.dart';
import 'package:get/get.dart';

class HttpClient {
  /// Handles HTTP responses and checks for token expiration
  static Future<void> _handleTokenExpiration(http.Response response) async {
    if (response.statusCode == 400 || response.statusCode == 401) {
      try {
        final responseData = jsonDecode(response.body);
        final message = responseData['message']?.toString().toLowerCase() ?? '';

        // Check if the error is related to JWT expiration
        if (message.contains('jwt expired') ||
            message.contains('token expired') ||
            message.contains('unauthorized') ||
            response.statusCode == 401) {

          debugPrint('🔒 Token expired. Logging out user...');

          // Clear all stored data
          await SharedPreferencesHelper.clearAllData();

          // Navigate to sign-in screen
          Get.offAllNamed(AppRoute.signInScreen);

          // Show notification to user
          Get.snackbar(
            'Session Expired',
            'Your session has expired. Please log in again.',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3),
          );
        }
      } catch (e) {
        debugPrint('Error parsing response: $e');
      }
    }
  }

  /// GET request with automatic token expiration handling
  static Future<http.Response> get(
    Uri url, {
    Map<String, String>? headers,
  }) async {
    final token = await SharedPreferencesHelper.getAccessToken();

    final finalHeaders = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
      ...?headers,
    };

    final response = await http.get(url, headers: finalHeaders);

    // Check for token expiration
    await _handleTokenExpiration(response);

    return response;
  }

  /// POST request with automatic token expiration handling
  static Future<http.Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    final token = await SharedPreferencesHelper.getAccessToken();

    final finalHeaders = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
      ...?headers,
    };

    final response = await http.post(
      url,
      headers: finalHeaders,
      body: body,
      encoding: encoding,
    );

    // Check for token expiration
    await _handleTokenExpiration(response);

    return response;
  }

  /// PATCH request with automatic token expiration handling
  static Future<http.Response> patch(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    final token = await SharedPreferencesHelper.getAccessToken();

    final finalHeaders = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
      ...?headers,
    };

    final response = await http.patch(
      url,
      headers: finalHeaders,
      body: body,
      encoding: encoding,
    );

    // Check for token expiration
    await _handleTokenExpiration(response);

    return response;
  }

  /// DELETE request with automatic token expiration handling
  static Future<http.Response> delete(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    final token = await SharedPreferencesHelper.getAccessToken();

    final finalHeaders = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
      ...?headers,
    };

    final response = await http.delete(
      url,
      headers: finalHeaders,
      body: body,
      encoding: encoding,
    );

    // Check for token expiration
    await _handleTokenExpiration(response);

    return response;
  }

  /// Multipart request with automatic token expiration handling
  static Future<http.StreamedResponse> sendMultipart(
    http.MultipartRequest request,
  ) async {
    final token = await SharedPreferencesHelper.getAccessToken();

    // Add token to headers
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    final streamedResponse = await request.send();

    // Convert to Response to check for token expiration
    final response = await http.Response.fromStream(streamedResponse);

    // Check for token expiration
    await _handleTokenExpiration(response);

    // Return the original streamed response
    // Note: For multipart, we need to re-create the stream
    return http.StreamedResponse(
      Stream.value(response.bodyBytes),
      response.statusCode,
      headers: response.headers,
      request: streamedResponse.request,
    );
  }
}
