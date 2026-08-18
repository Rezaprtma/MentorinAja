//**
// frontend/core/navigation/navigation_extensions.dart
//
// frontend:
// Navigation service. Menyediakan navigation utilities dan InheritedWidget.
//
// backend:
// File ini tidak memiliki dependency langsung terhadap backend.
//
// api:
// File ini tidak mendefinisikan atau memanggil API secara langsung.
//
// qa:
// QA perlu memvalidasi navigation behavior dan deep linking.
//**
import 'package:flutter/material.dart';

import 'navigation_service.dart';

extension AppNavigationContext on BuildContext {
  NavigationService get nav => NavigationService.of(this);

  Future<T?> push<T>(String routeName, {Object? arguments}) =>
      nav.push<T>(routeName, arguments: arguments);

  Future<T?> pushPage<T>(Widget page) => nav.pushCustom<T>(page);

  Future<T?> pushReplacement<T, TO>(String routeName, {TO? result}) =>
      nav.pushReplacement<T, TO>(routeName, result: result);

  Future<T?> pushAndRemoveAll<T>(String routeName) =>
      nav.pushAndRemoveAll<T>(routeName);

  bool pop<T>([T? result]) => nav.pop<T>(result);

  void popToRoot() => nav.popToRoot();

  bool get canPop => nav.canPop;
}
