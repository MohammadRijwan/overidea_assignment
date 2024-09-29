import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:overidea_assignment/src/core/utils/app_constant.dart';
import 'package:overidea_assignment/src/feature/chat/domain/model/message.dart';

import '../../domain/datasource/i_db.dart';

class FirebaseDb implements IDb {
  @override
  Future<Either<Exception, String>> login(
      {required String email, required String password}) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return const Right('Success');
    } on FirebaseAuthException catch (e) {
      log('Exception:::: ${e.code}');
      switch (e.code) {
        case 'invalid-credential':
          return Left(Exception(
              'Invalid credentials. Please check your email and password.'));
        case 'user-not-found':
          return Left(Exception('No user found with this email/username.'));
        case 'wrong-password':
          return Left(Exception(
              'The password is invalid or the user does not have a password.'));
        default:
          return Left(
              Exception('Something went wrong please try again later.'));
      }
    }
  }

  @override
  Future<Either<Exception, String>> signUp(
      {required String email,
      required String password,
      required String name}) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      if (userCredential.additionalUserInfo!.isNewUser) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'email': email,
          'registerDate': DateTime.now().toIso8601String(),
          'name': name,
          'userId': userCredential.user!.uid,
        });
      }
      return const Right('Success');
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          return Left(Exception('The email address is badly formatted.'));
        case 'email-already-in-use':
          return Left(Exception(
              'The email address is already in use by another account.'));
        case 'weak-password':
          return Left(Exception('Password should be at least 6 characters.'));
        default:
          return Left(
              Exception('Something went wrong please try again later.'));
      }
    }
  }

  @override
  Stream<QuerySnapshot> fetchUsers() {
    return FirebaseFirestore.instance.collection('users').snapshots();
  }

  @override
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Stream<QuerySnapshot> fetchMessages({required String chatRoomId}) {
    var snapshot = FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
    log('snapshot: $snapshot');
    return snapshot;
  }

  @override
  Future<Either<Exception, bool>> sendMessage(
      {required String chatRoomId, required Message message}) async {
    try {
      await FirebaseFirestore.instance
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection('messages')
          .add(message.toMap());
      return const Right(true);
    } catch (e) {
      return Left(Exception('Something went wrong please try again.'));
    }
  }

  @override
  Future<Either<Exception, bool>> storeFcm() async {
    var userId = FirebaseAuth.instance.currentUser!.uid;

    try {
      await FirebaseFirestore.instance
          .collection('store_fcm')
          .doc(userId)
          .set({'fcm': AppConstant.firebaseToken}, SetOptions(merge: true));

      return const Right(true);
    } catch (e) {
      return Left(Exception('Something went wrong please try again.'));
    }
  }
}
