
import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

@freezed
abstract class ValueFailure<T> with _$ValueFailure<T> {
  const factory ValueFailure.invalidEmail({
    required String failedValue,
  }) = InvalidEmail<T>;
  const factory ValueFailure.shortPassword({
    required String shortPassword,
  }) = ShortPassword<T>;

  //Notes failures
  const factory ValueFailure.exceedingLength({
    required String failedValue,
    required int max,
  }) = ExceedingLength<T>;
  const factory ValueFailure.empty({
    required String failedValue,
  }) = Empty<T>;
  const factory ValueFailure.multiline({
    required String failedValue,
  }) = Multiline<T>;
  const factory ValueFailure.listTooLong({
    required String failedValue,
    required int max,
  }) = ListTooLong<T>;
}