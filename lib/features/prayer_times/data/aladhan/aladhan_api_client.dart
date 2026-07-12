import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'aladhan_method_config.dart';
import 'aladhan_prayer_times.dart';

/// Client for the Aladhan prayer times REST API.
abstract final class AladhanApiClient {
  static const baseUrl = 'https://api.aladhan.com/v1';
  static const _timeout = Duration(seconds: 25);
  static const _maxAttempts = 3;

  static Future<AladhanPrayerTimes?> fetchTimingsForDate({
    required double latitude,
    required double longitude,
    required DateTime date,
    String? country,
    String? timezone,
    int? methodOverride,
  }) async {
    final method =
        methodOverride ?? AladhanMethodConfig.calculationMethodForCountry(country);
    final formattedDate =
        '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';

    var url = '$baseUrl/timings/$formattedDate'
        '?latitude=$latitude'
        '&longitude=$longitude'
        '&method=$method';
    if (timezone != null && timezone.isNotEmpty) {
      url += '&timezonestring=${Uri.encodeComponent(timezone)}';
    }

    final data = await _getJson(url);
    if (data == null || data['data'] == null) return null;
    return AladhanPrayerTimes.fromJson(data['data'] as Map<String, dynamic>);
  }

  /// Fetches an entire month in one request (much faster than per-day calls).
  static Future<List<Map<String, dynamic>>?> fetchCalendarMonth({
    required int year,
    required int month,
    required double latitude,
    required double longitude,
    String? country,
    String? timezone,
    int? methodOverride,
  }) async {
    final method =
        methodOverride ?? AladhanMethodConfig.calculationMethodForCountry(country);

    var url = '$baseUrl/calendar/$year/$month'
        '?latitude=$latitude'
        '&longitude=$longitude'
        '&method=$method';
    if (timezone != null && timezone.isNotEmpty) {
      url += '&timezonestring=${Uri.encodeComponent(timezone)}';
    }

    final data = await _getJson(url);
    if (data == null || data['data'] is! List) return null;
    return List<Map<String, dynamic>>.from(data['data'] as List);
  }

  static Future<Map<String, dynamic>?> _getJson(String url) async {
    for (var attempt = 0; attempt < _maxAttempts; attempt++) {
      try {
        final response = await http.get(Uri.parse(url)).timeout(
              _timeout,
              onTimeout: () {
                debugPrint('Aladhan API timeout (attempt ${attempt + 1}): $url');
                return http.Response('', 408);
              },
            );

        if (response.statusCode == 200) {
          final decoded = jsonDecode(response.body) as Map<String, dynamic>?;
          if (decoded != null && decoded['code'] == 200) {
            return decoded;
          }
        } else if (response.statusCode == 408) {
          // timeout — retry below
        } else {
          debugPrint(
            'Aladhan API HTTP ${response.statusCode} (attempt ${attempt + 1})',
          );
        }
      } catch (error) {
        debugPrint('Aladhan API error (attempt ${attempt + 1}): $error');
      }

      if (attempt < _maxAttempts - 1) {
        await Future<void>.delayed(Duration(seconds: 1 << attempt));
      }
    }
    return null;
  }
}
