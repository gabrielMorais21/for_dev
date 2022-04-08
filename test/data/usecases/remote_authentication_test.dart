

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';


import 'package:ForDev/data/usecases/remote_authentication.dart';
import 'package:ForDev/domain/usecases/usecases.dart';
import 'package:ForDev/data/http/http.dart';




class HttpClientSpy extends Mock implements HttpClient {
  
}

void main() {
  RemoteAuthencation sut;
  HttpClientSpy httpClient;
  String url;
  AuthenticationParams params;

  setUp((){
    // arrange
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthencation(httpClient: httpClient, url: url);
    params = AuthenticationParams(email: faker.internet.email(), secret: faker.internet.password());
  });

  test('Should call HttpClient with correct Url', () async {

    // action
    await sut.auth(params);
    // assert
    verify(httpClient.request(url: url, method: 'post', body: {'email': params.email, "password": params.secret}));
  });
}
