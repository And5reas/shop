import 'package:flutter/material.dart';

class Badgee extends StatelessWidget {
  final Widget child;
  final String value;
  final Color? backgroundColor;

  const Badgee({
    required this.child,
    required this.value,
    this.backgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          right: 8,
          top: 4,
          child: Container(
            constraints: BoxConstraints(
              minHeight: 16,
              minWidth: 16,
            ),
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color:
                    backgroundColor ?? Theme.of(context).colorScheme.secondary),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10, color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}
