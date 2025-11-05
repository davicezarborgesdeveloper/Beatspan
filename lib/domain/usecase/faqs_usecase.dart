import 'package:dartz/dartz.dart';

import '../../data/failure.dart';
import '../model/faqs.dart';
import '../repository/repository.dart';
import 'base_usecase.dart';

class FaqsUseCase extends BaseUseCase<void, Object> {
  final Repository _repository;
  FaqsUseCase(this._repository);

  @override
  Future<Either<Failure, List<Faq>>> execute(void input) async {
    return _repository.getFaqs();
  }
}
