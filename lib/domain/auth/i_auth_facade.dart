import 'package:dartz/dartz.dart';
import 'package:ddd_practice_flutter/domain/auth/auth_failure.dart';

abstract class IAuthFacade {
  // Why we don't use Future<Either<AuthFailure, void>>?
  // Dart's void is only a keyword, not a type, and it cannot be used as a generic type parameter.
  // Swift's Void is actually a type, so you can use it in generics. Kotlin uses Unit which is also a regular type. 
  // Thankfully, the dartz package provides us, Dart programmers, with a Unit type too!
  Future<Either<AuthFailure, Unit>> registerWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<Either<AuthFailure, Unit>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<Either<AuthFailure, Unit>> signInWithGoogle();
}