import 'package:interview_portal/domian/repository/candidate_repository.dart';

class GetCandidatesUseCase {
  final CandidateRepository repository;

  GetCandidatesUseCase(this.repository);

  Future<List<dynamic>> call() async {
    return await repository.getCandidates();
  }
}
