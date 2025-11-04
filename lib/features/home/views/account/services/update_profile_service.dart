// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';
import 'package:electronic/core/constants/app_urls.dart';
import 'package:electronic/core/storage/storage_keys.dart';
import 'package:electronic/core/storage/storage_services.dart';
import 'package:electronic/core/util/app_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../model/update_profile_model.dart';

class UpdateProfileServiceInsideApp {
  // Singleton pattern
  static final UpdateProfileServiceInsideApp _instance = UpdateProfileServiceInsideApp._internal();
  factory UpdateProfileServiceInsideApp() => _instance;
  UpdateProfileServiceInsideApp._internal();

  // Update user profile with form data using UpdateProfileModel
  Future<Map<String, dynamic>> updateProfileInsideApp({
    required UpdateProfileModel profileData,
    File? profileImage,
  }) async {
    const String tag = 'UpdateProfileService';
    
    try {
      // Log start of API call
      AppLogger.apiRequest(
        method: 'PATCH',
        endpoint: '${AppUrls.baseUrl}${AppUrls.updateProfileInsideApp}',
        body: profileData.toJson(),
      );

      // Get the access token from local storage
      await LocalStorage.getAllPrefData();
      final token = LocalStorage.token;

      if (token.isEmpty) {
        final error = 'No authentication token found';
        AppLogger.error(error, tag: tag);
        throw Exception(error);
      }

      // Create multipart request
      var request = http.MultipartRequest(
        'PATCH',
        Uri.parse('${AppUrls.baseUrl}${AppUrls.updateProfileInsideApp}'),
      );

      // Add headers
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      // Add form fields (remove null values)
      final profileDataMap = profileData.toJson()..removeWhere((key, value) => value == null);
      profileDataMap.forEach((key, value) {
        if (value != null) {
          request.fields[key] = value.toString();
        }
      });
      
      // Log request fields
      AppLogger.debug(
        'Request fields: ${request.fields}',
        tag: tag,
      );

      // Add profile image if provided
      if (profileImage != null) {
        final fileStream = http.ByteStream(profileImage.openRead());
        final fileLength = await profileImage.length();
        final multipartFile = http.MultipartFile(
          'image',
          fileStream,
          fileLength,
          filename: profileImage.path.split('/').last,
          contentType: MediaType('image', 'jpeg'),
        );
        request.files.add(multipartFile);
        
        AppLogger.debug('Uploading image: ${profileImage.path}, Size: $fileLength bytes', tag: tag);
      }

      // Send the request
      final startTime = DateTime.now();
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      final duration = DateTime.now().difference(startTime);

      final responseData = json.decode(response.body);

    
      AppLogger.apiResponse(
        method: 'PATCH',
        endpoint: '${AppUrls.baseUrl}${AppUrls.updateProfileInsideApp}',
        statusCode: response.statusCode,
        responseData: responseData,
        duration: duration,
      );
      
      if (kDebugMode) {
        // Pretty print the response in debug mode
        final prettyResponse = JsonEncoder.withIndent('  ').convert(responseData);
        if (kDebugMode) {
          print('Response body:');
          print(prettyResponse);
        }
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        AppLogger.success(
          'Profile updated successfully',
          tag: tag,
        );
        // Update local storage with the new profile data
        if (profileData.firstName.isNotEmpty) {
          await LocalStorage.preferences?.setString(
            LocalStorageKeys.myName, 
            '${profileData.firstName} ${profileData.lastName}'.trim()
          );
          LocalStorage.myName = '${profileData.firstName} ${profileData.lastName}'.trim();
        }
        
        // Store image URL from backend response if available
        if (responseData['data'] != null && responseData['data']['image'] != null) {
          final imageUrl = responseData['data']['image'] as String;
          await LocalStorage.preferences?.setString(LocalStorageKeys.myImage, imageUrl);
          LocalStorage.myImage = imageUrl;
        } else if (responseData['image'] != null) {
          final imageUrl = responseData['image'] as String;
          await LocalStorage.preferences?.setString(LocalStorageKeys.myImage, imageUrl);
          LocalStorage.myImage = imageUrl;
        }
        
        return {
          'success': true,
          'message': 'Profile updated successfully',
          'data': responseData,
        };
      } else {
        final errorMessage = 'Failed to update profile: ${responseData['message'] ?? 'Unknown error'}';
        AppLogger.error(
          errorMessage,
          tag: tag,
          error: responseData,
        );
        throw Exception(errorMessage);
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to update profile: $e',
        tag: tag,
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}