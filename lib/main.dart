import 'package:ddd_practice_flutter/injection.dart';
import 'package:ddd_practice_flutter/presentation/core/app_widget.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

void main() {
  configureInjection(Environment.prod);
  runApp(const AppWidget());
}

