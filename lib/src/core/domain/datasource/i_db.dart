import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:overidea_assignment/src/feature/chat/domain/model/message.dart';

abstract class IDb {
  Future<Either<Exception, String>> login(
      {required String email, required String password});

  Future<Either<Exception, String>> signUp(
      {required String email, required String password, required String name});

  Stream<QuerySnapshot> fetchUsers();

  // Future<Either<Exception, UserModel>> fetchCurrentUser();

  Future<void> logout();

  Future<Either<Exception, bool>> sendMessage(
      {required String chatRoomId, required Message message});

  Stream<QuerySnapshot> fetchMessages({required String chatRoomId});

  Future<Either<Exception, bool>> storeFcm();
}
