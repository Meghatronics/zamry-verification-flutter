import '../../../core/presentation/presentation.dart';
import '../../shared/components/loaders/app_loading_indicator.dart';
import '../../shared/components/others/custom_app_bar.dart';
import 'package:flutter/material.dart';

class WaitingView extends StatelessWidget {
  const WaitingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: 'Aprify'),
      body: Center(
        child: EmptyStateWidget(
          mainText: 'Verifying your number',
          illustration: AppLoadingIndicator(),
          illustrationSize: 56,
        ),
      ),
    );
  }
}
