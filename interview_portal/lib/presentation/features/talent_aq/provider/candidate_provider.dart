import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interview_portal/core/network/dio_client.dart';
import 'package:interview_portal/data/datasources/candidate_remote_datasource.dart';
import 'package:interview_portal/data/repository_impl/candidate_repository_impl.dart';
import 'package:interview_portal/domian/usecase/get_candidate_usecase.dart';


final dioClientProvider = Provider((ref) => DioClient());


final candidateRemoteDataSourceProvider = Provider(
  (ref) => CandidateRemoteDataSource(ref.read(dioClientProvider)),
);

final candidateRepositoryProvider = Provider(
  (ref) => CandidateRepositoryImpl(ref.read(candidateRemoteDataSourceProvider)),
);


final getCandidatesUseCaseProvider = Provider(
  (ref) => GetCandidatesUseCase(ref.read(candidateRepositoryProvider)),
);
