import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';

abstract class IHomeRepo {
  Stream<QuerySnapshot> fetchUsers();
  Future<Either<Exception, bool>> storeFcm();
}
