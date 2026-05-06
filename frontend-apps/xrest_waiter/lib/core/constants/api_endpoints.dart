/*
 * File: api_endpoints.dart
 * Author: Elite Flutter Agent
 * Date: 2026-05-01
 * Description: Centralized registry for all API endpoints and base URLs.
 */

class ApiEndpoints {
  // Base URL configured for local testing as requested
  static const String baseUrl = 'http://localhost/xrest';

  // Auth Module
  static const String login = '$baseUrl/auth/login';
}