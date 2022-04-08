import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:meta/meta.dart';

import 'package:ForDev/domain/usecases/authentication.dart';
class RemoteAuthencation {
  final HttpClient httpClient;
  final String url;

  RemoteAuthencation({@required this.httpClient, @required this.url});

  Future<void> auth(AuthenticationParams params) async {
    final body = {'email': params.email, 'password': params.secret};
    await httpClient.request(url: url, method: 'post', body: body);
  }
}

abstract class HttpClient {
  Future<void> request({@required String url, @required String method, Map body});
}

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
