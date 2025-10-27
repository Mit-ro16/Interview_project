import 'package:interview_portal/data/datasources/auth_remote_datasource.dart';
import 'package:interview_portal/domian/repository/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthRemoteDataSource dataSource;
  AuthRepositoryImpl(this.dataSource);
  @override
  Future<Map<String, dynamic>> login(String email, String password) {
    return dataSource.login(email, password);
  }


}
