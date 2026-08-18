//**
// frontend/core/lifecycle/screen_lifecycle.dart
//
// frontend:
// Source file. Bagian dari MentorinAja frontend.
//
// backend:
// File ini tidak memiliki dependency langsung terhadap backend.
//
// api:
// File ini tidak mendefinisikan atau memanggil API secara langsung.
//
// qa:
// QA perlu memvalidasi file behavior sesuai dengan purpose.
//**
import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';

enum ScreenState { loading, empty, error, ready, offline }

class ScreenLifecycleWrapper extends StatelessWidget {
  const ScreenLifecycleWrapper({
    super.key,
    required this.state,
    required this.ready,
    this.onRetry,
    this.loadingWidget,
    this.emptyIcon = Icons.inbox_outlined,
    this.emptyTitle = 'Nothing here yet',
    this.emptyMessage,
    this.emptyActionLabel,
    this.emptyAction,
    this.errorIcon = Icons.error_outline,
    this.errorTitle = 'Something went wrong',
    this.errorMessage,
    this.errorActionLabel = 'Retry',
    this.offlineIcon = Icons.wifi_off_outlined,
    this.offlineTitle = 'No connection',
    this.offlineMessage,
    this.offlineActionLabel = 'Retry',
  });

  final ScreenState state;
  final Widget ready;
  final VoidCallback? onRetry;
  final Widget? loadingWidget;

  final IconData emptyIcon;
  final String emptyTitle;
  final String? emptyMessage;
  final String? emptyActionLabel;
  final VoidCallback? emptyAction;

  final IconData errorIcon;
  final String errorTitle;
  final String? errorMessage;
  final String errorActionLabel;

  final IconData offlineIcon;
  final String offlineTitle;
  final String? offlineMessage;
  final String offlineActionLabel;

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      ScreenState.loading =>
        loadingWidget ?? const AppCircularLoader(centered: true),
      ScreenState.empty => AppEmptyState(
        icon: emptyIcon,
        title: emptyTitle,
        message: emptyMessage,
        actionLabel: emptyActionLabel,
        onAction: emptyAction ?? onRetry,
      ),
      ScreenState.error => AppEmptyState(
        icon: errorIcon,
        title: errorTitle,
        message: errorMessage,
        actionLabel: errorActionLabel,
        onAction: onRetry,
      ),
      ScreenState.offline => AppEmptyState(
        icon: offlineIcon,
        title: offlineTitle,
        message: offlineMessage,
        actionLabel: offlineActionLabel,
        onAction: onRetry,
      ),
      ScreenState.ready => ready,
    };
  }
}

mixin ScreenLifecycleMixin<T extends StatefulWidget> on State<T> {
  ScreenState get initialState => ScreenState.loading;

  ScreenState get screenState => _screenState;
  set screenState(ScreenState value) {
    if (_screenState != value) {
      setState(() => _screenState = value);
    }
  }

  ScreenState _screenState = ScreenState.loading;

  @override
  void initState() {
    super.initState();
    _screenState = initialState;
  }
}
