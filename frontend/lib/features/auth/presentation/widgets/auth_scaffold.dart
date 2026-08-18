//**
// frontend/features/auth/presentation/widgets/auth_scaffold.dart
//
// frontend:
// Reusable widget. Menampilkan komponen UI yang dapat digunakan di berbagai places.
//
// backend:
// File ini tidak memiliki dependency langsung terhadap backend.
//
// api:
// File ini tidak mendefinisikan atau memanggil API secara langsung.
//
// qa:
// QA perlu memvalidasi widget rendering, responsiveness, dan accessibility.
//**
import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    this.child,
    this.contentBuilder,
    this.appBar,
    this.maxWidth = 480,
    this.background,
    this.backgroundColor,
  }) : assert(
         child != null || contentBuilder != null,
         'AuthScaffold requires either child or contentBuilder.',
       );

  final Widget? child;

  final Widget Function(BuildContext context, BoxConstraints constraints)?
  contentBuilder;

  final PreferredSizeWidget? appBar;

  final double maxWidth;

  final Widget? background;

  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? context.appColors.background,
      appBar: appBar,
      body: Stack(
        fit: StackFit.expand,
        children: [
          ?background,
          AppSafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final content = contentBuilder != null
                    ? contentBuilder!(context, constraints)
                    : child!;

                Widget body = content;
                if (contentBuilder == null) {
                  body = Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxWidth),
                      child: content,
                    ),
                  );
                } else {
                  body = ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: content,
                  );
                }

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: body,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
