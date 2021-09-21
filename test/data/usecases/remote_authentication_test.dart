import 'package:flutter_test/flutter_test.dart';
import 'package:for_dev/data/usecases/usecases.dart';
import 'package:mockito/mockito.dart';
import 'package:faker/faker.dart';
import 'package:for_dev/domain/usecases/usecases.dart';
import 'package:for_dev/data/http/http.dart';






class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  HttpClientSpy? httpClient;
  String? url;
  RemoteAuthentication? sut;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient!, url: url!);
  });
  test('Should call HttpClient with correct values', () async {
    final params = AuthenticationParams(
        email: faker.internet.email(), password: faker.internet.password());
    await sut!.auth(params);

    verify(httpClient!.request(
        url: url!,
        method: 'post',
        body: {"email": params.email, "password": params.password}));
  });
}
