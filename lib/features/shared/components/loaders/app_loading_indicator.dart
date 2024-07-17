import 'package:flutter/material.dart';

class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({
    super.key,
    this.size = const Size(40, 32),
  });

  final Size size;
  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator();
  }
}
