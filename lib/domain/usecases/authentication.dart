
import 'package:for_dev/domain/entities/account_entity.dart';




abstract class  Authentication {
  Future<AccountEntity> auth({required String email, required String password});
}