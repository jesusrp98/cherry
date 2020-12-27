import 'package:cherry/services/index.dart';
import 'package:cherry/util/index.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import './mock.dart';

void main() {
  group('LaunchesService', () {
    Dio client;
    LaunchesService service;

    setUp(() {
      client = MockClient();
      service = LaunchesService(client);
    });

    test('throws AssertionError when client is null', () {
      expect(() => LaunchesService(null), throwsAssertionError);
    });

    test('returns request when client returns 200', () async {
      const json = 'Just a normal JSON here';
      final response = MockResponse();

      when(response.statusCode).thenReturn(200);
      when(response.data).thenReturn(json);
      when(
        client.post(
          Url.launches,
          data: ApiQuery.launch,
        ),
      ).thenAnswer((_) => Future.value(response));

      final output = await service.getLaunches();
      expect(output.data, json);
    });
  });
}
