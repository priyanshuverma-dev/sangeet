import 'package:flutter/material.dart';

class PlayButton extends StatelessWidget {
  final VoidCallback onPressed;
  const PlayButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: "Play",
      onPressed: onPressed,
      icon: const Icon(
        Icons.play_arrow_rounded,
        size: 35,
        color: Colors.white,
      ),
      style: IconButton.styleFrom(
        backgroundColor: Colors.teal,
      ),
    );
  }
}
