import 'package:ForDev/domain/entities/account_entity.dart';
import 'package:meta/meta.dart';

import '../../domain/usecases/usecases.dart';

import '../http/http.dart';

class RemoteAuthencation {
  final HttpClient httpClient;
  final String url;

  RemoteAuthencation({@required this.httpClient, @required this.url});

  Future<void> auth(AuthenticationParams params) async {
    final body  = RemoteAuthenticationParams.fromDomain(params).toJson();
    await httpClient.request(url: url, method: 'post', body: body);
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
