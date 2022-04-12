
import 'package:meta/meta.dart';

import '../../domain/usecases/usecases.dart';
import '../../domain/helpers/domain_error.dart';
import '../../domain/entities/entities.dart';
import '../http/http.dart';

class RemoteAuthencation {
  final HttpClient httpClient;
  final String url;

  RemoteAuthencation({@required this.httpClient, @required this.url});

  Future<AccountEntity> auth(AuthenticationParams params) async {
    final body = RemoteAuthenticationParams.fromDomain(params).toJson();
    try {
     final httpResponse = await httpClient.request(url: url, method: 'post', body: body);
     return AccountEntity.fromJson(httpResponse);
    } on HttpError catch (error) {
      error == HttpError.unauthorized
          ? throw DomainError.invalidCredentials
          : throw DomainError.unexpected;
    }
  }
}

class RemoteAuthenticationParams {
  final String email;
  final String password;

  RemoteAuthenticationParams({@required this.email, @required this.password});

  factory RemoteAuthenticationParams.fromDomain(AuthenticationParams params) =>
      RemoteAuthenticationParams(email: params.email, password: params.secret);

  Map toJson() => {'email': email, 'password': password};
}
