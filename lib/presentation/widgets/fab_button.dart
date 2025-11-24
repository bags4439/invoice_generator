import 'package:flutter/material.dart';
import '../../core/constants.dart';

class FABButton extends StatelessWidget {
  final VoidCallback onPressed;

  const FABButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: AppColors.primary,
      onPressed: onPressed,
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }
}
