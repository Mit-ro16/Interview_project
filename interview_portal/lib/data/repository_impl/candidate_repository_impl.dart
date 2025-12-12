import 'package:interview_portal/data/datasources/candidate_remote_datasource.dart';
import 'package:interview_portal/domian/repository/candidate_repository.dart';

class CandidateRepositoryImpl implements CandidateRepository {
  final CandidateRemoteDataSource remoteDataSource;

  CandidateRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<dynamic>> getCandidates() async {
    return await remoteDataSource.fetchCandidates();
  }
}
