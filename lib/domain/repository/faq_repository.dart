import 'package:dartz/dartz.dart';
import '../../data/failure.dart';
import '../model/faqs.dart';

abstract class FaqRepository {
  Future<Either<Failure, List<Faq>>> getFaqs();
}
