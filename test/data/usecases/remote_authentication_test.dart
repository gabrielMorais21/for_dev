import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:ForDev/domain/usecases/usecases.dart';
import 'package:ForDev/domain/helpers/helpers.dart';

import 'package:ForDev/data/http/http.dart';
import 'package:ForDev/data/usecases/remote_authentication.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  RemoteAuthencation sut;
  HttpClientSpy httpClient;
  String url;
  AuthenticationParams params;

  Map mockValidData() =>
      {'accessToken': faker.guid.guid(), 'name': faker.person.name()};

  PostExpectation mockRequest() => when(httpClient.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      body: anyNamed('body')));

  void mockHttpData(Map data) {
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  setUp(() {
    // arrange
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthencation(httpClient: httpClient, url: url);
    params = AuthenticationParams(
        email: faker.internet.email(), secret: faker.internet.password());
    // mockando caso de sucesso
    mockHttpData(mockValidData());
  });

  test('Should call HttpClient with correct Url', () async {
    // action
    await sut.auth(params);
    // assert
    verify(httpClient.request(
        url: url,
        method: 'post',
        body: {'email': params.email, "password": params.secret}));
  });

  test("Should throw UnexpectedError if httpClient returns 400", () {
    mockHttpError(HttpError.badRequest);
    final future = sut.auth(params);
    // assert
    expect(future, throwsA(DomainError.unexpected));
  });

  test("Should throw UnexpectedError if httpClient returns 404", () {
    mockHttpError(HttpError.notFound);
    final future = sut.auth(params);
    // assert
    expect(future, throwsA(DomainError.unexpected));
  });

  test("Should throw UnexpectedError if httpClient returns 500", () {
    mockHttpError(HttpError.serverError);
    final future = sut.auth(params);
    // assert
    expect(future, throwsA(DomainError.unexpected));
  });

  test("Should throw InvalidCrendentialsError if httpClient returns 401", () {
    mockHttpError(HttpError.unauthorized);
    final future = sut.auth(params);
    // assert
    expect(future, throwsA(DomainError.invalidCredentials));
  });

  test("Should return an Account if httpClient returns 200", () async {
    final validData = mockValidData();
    mockHttpData(validData);

    final account = await sut.auth(params);
    // assert
    expect(account.token, validData['accessToken']);
  });

  test(
      "Should throw UnexpectedError if httpClient returns 200 with invalid data",
      () {
    mockHttpData({'invalid_key': 'invalid_value'});

    final future = sut.auth(params);
    // assert
    expect(future, throwsA(DomainError.unexpected));
  });
}
