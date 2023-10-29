import 'package:flutter/material.dart';

class FormActionButtons extends StatelessWidget {
  final bool isSubmitting;
  final VoidCallback onSave;

  const FormActionButtons({
    super.key,
    required this.isSubmitting,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: [
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Retourner',
            style: TextStyle(color: Colors.black),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
          ),
          onPressed: isSubmitting ? null : onSave,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              const Text(
                'Enregister',
                style: TextStyle(color: Colors.white),
              ),
              if (isSubmitting)
                const Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                )
            ],
          ),
        ),
      ],
    );
  }
}
