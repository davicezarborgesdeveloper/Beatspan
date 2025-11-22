import 'package:dartz/dartz.dart';

import '../failure.dart';
import '../../domain/model/faqs.dart';

import '../../domain/repository/faq_repository.dart';
import '../../presentation/resource/assets_manager.dart';
import '../data_source/faq_local_data_source.dart';

class FaqRepositoryImpl implements FaqRepository {
  final FaqLocalDataSource _localDataSource;
  FaqRepositoryImpl(this._localDataSource);
  @override
  Future<Either<Failure, List<Faq>>> getFaqs() async {
    try {
      final response = await _localDataSource.getDataFromJson(JsonAssets.faqs);
      final List<Faq> listFaq = <Faq>[];
      response.forEach((res) => listFaq.add(Faq.fromJson(res)));
      return Right(listFaq);
    } on Exception catch (e) {
      return Left(Failure(0, e.toString()));
    }
  }
}
