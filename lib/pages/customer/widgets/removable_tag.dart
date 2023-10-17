import 'package:flutter/material.dart';

class RemovableTag extends StatelessWidget {
  const RemovableTag({Key? key, required this.text, required this.onTapRemove})
      : super(key: key);
  final String text;
  final VoidCallback onTapRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 5),
      margin: const EdgeInsets.only(right: 5),
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: const TextStyle(color: Colors.white),
          ),
          InkWell(
            onTap: onTapRemove,
            child: const Icon(
              Icons.close,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
