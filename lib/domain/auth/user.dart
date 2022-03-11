import 'package:ddd_practice_flutter/domain/auth/value_objects.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
abstract class User with _$User {
   factory User({
    required UniqueId id,
  }) = _User;
}