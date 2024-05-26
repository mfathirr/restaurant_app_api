import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:restaurant_app_api/data/api/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:restaurant_app_api/data/model/restaurant.dart';

import 'restaurant_list_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('fetch Restaurant', () {
    test('return restaurant if the http call completes successfully', () async {
      final client = MockClient();
      when(client.get(Uri.parse("https://restaurant-api.dicoding.dev/list")))
          .thenAnswer((_) async => http.Response(
              '{"error":false,"message":"success","count":20,"restaurants":[]}',
              200));
      expect(await ApiService(client), isA<ApiService>());
    });
  });
}
