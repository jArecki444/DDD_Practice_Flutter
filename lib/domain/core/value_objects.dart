import 'package:dartz/dartz.dart';
import 'package:ddd_practice_flutter/domain/core/failures.dart';
import 'package:flutter/foundation.dart';

import 'errors.dart';

@immutable
abstract class ValueObject<T> {
  const ValueObject();
  Either<ValueFailure<T>, T> get value;

  Either<ValueFailure<dynamic>, Unit> get failureOrUnit {
    return value.fold(
      (l) => left(l),
      (r) => right(unit),
    );
  }

  bool isValid() => value.isRight();

  ///Throws [UnexpectedValueError] containing the [ValueFailure]
  T getOrCrash() => value.fold(
        (leftErrorMsg) => throw UnexpectedValueError(leftErrorMsg),
        ((r) => r), // we can use just id instead
      );

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is ValueObject<T> && o.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Value($value)';
}
