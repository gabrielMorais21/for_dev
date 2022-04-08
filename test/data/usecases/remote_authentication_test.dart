import 'dart:io';

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:meta/meta.dart';

class RemoteAuthencation {
  final HttpClient httpClient;
  final String url;

  RemoteAuthencation({@required this.httpClient, @required this.url});

  Future<void> auth() async {
    await httpClient.request(url: url, method: 'post');
  }
}

abstract class HttpClient {
  Future<void> request({@required String url, @required String method});
}

class HttpClientSpy extends Mock implements HttpClient {
  
}

void main() {
  RemoteAuthencation sut;
  HttpClientSpy httpClient;
  String url;

  setUp((){
    // arrange
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthencation(httpClient: httpClient, url: url);
  });

  test('Should call HttpClient with correct Url', () async {

    // action
    await sut.auth();
    // assert
    verify(httpClient.request(url: url, method: 'post'));
  });
}
