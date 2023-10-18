import 'package:flutter/material.dart';

class RemovableTag extends StatelessWidget {
  const RemovableTag({
    Key? key,
    required this.text,
    required this.onTapRemove,
    this.readOnly = false,
  }) : super(key: key);
  final String text;
  final VoidCallback onTapRemove;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 5),
      margin: const EdgeInsets.only(right: 5, bottom: 5),
      decoration: BoxDecoration(
        color: readOnly ? Colors.grey[600] : Colors.black,
        borderRadius: const BorderRadius.all(
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
          if (!readOnly)
            InkWell(
              onTap: onTapRemove,
              child: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            )
          else
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: SizedBox(width: 5),
            )
        ],
      ),
    );
  }
}
