import 'package:flutter/material.dart';

class BaseSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String)? onSubmit;
  final void Function()? onPressed;

  const BaseSearchBar({
    super.key,
    required this.controller,
    required this.onSubmit,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: Theme.of(context).primaryColorLight.withOpacity(.2),
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 7),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search',
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(10),
          suffixIcon: IconButton(
            onPressed: onPressed,
            icon: const Icon(Icons.search),
          ),
        ),
        controller: controller,
        onSubmitted: onSubmit,
      ),
    );
  }
}
