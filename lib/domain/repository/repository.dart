import 'package:dartz/dartz.dart';
import '../../data/failure.dart';
import '../model/faqs.dart';

abstract class Repository {
  Future<Either<Failure, List<Faq>>> getFaqs();
}
