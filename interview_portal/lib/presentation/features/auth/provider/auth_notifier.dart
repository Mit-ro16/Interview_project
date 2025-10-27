import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interview_portal/core/network/dio_client.dart';
import 'package:interview_portal/data/datasources/auth_remote_datasource.dart';
import 'package:interview_portal/data/repository_impl/auth_repository_impl.dart';
import 'package:interview_portal/domian/usecase/login_usecase.dart';


final dioClientProvider = Provider((ref) => DioClient());

final authRemoteDataSourceProvider = Provider(
  (ref) => AuthRemoteDataSource(ref.read(dioClientProvider)),
);

final authRepositoryProvider = Provider(
  (ref) => AuthRepositoryImpl(ref.read(authRemoteDataSourceProvider)),
);


final loginUseCaseProvider = Provider(
  (ref) => LoginUseCase(ref.read(authRepositoryProvider)),
);

