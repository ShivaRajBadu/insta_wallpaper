import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({
    super.key,
    required this.progress,
  });

  final int progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 3,
      color: const Color.fromARGB(255, 234, 234, 234),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * progress / 100,
            color: const Color.fromARGB(255, 114, 97, 209),
          ),
        ],
      ),
    );
  }
}
