import 'dart:convert';

import 'package:favorite_restaurant_app/data/api/api_service.dart';
import 'package:favorite_restaurant_app/data/models/restaurant_list.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('return list restaurant', () async {
    final client = MockClient(
      (request) async {
        final response = {
          "error": false,
          "message": "success",
          "count": 20,
          "restaurants": []
        };
        return http.Response(json.encode(response), 200);
      },
    );

    expect(await ApiService(client).fetchList(), isA<RestaurantList>());
  });
}
