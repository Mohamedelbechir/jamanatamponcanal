import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jamanacanal/cubit/licenceForm/licence_form_cubit.dart';
import 'package:jamanacanal/cubit/notification/notification_cubit.dart';
import 'package:jamanacanal/utils/utils_values.dart';
import 'package:jamanacanal/widgets/notification_widget.dart';

class LicencePage extends StatefulWidget {
  const LicencePage({super.key});

  @override
  State<LicencePage> createState() => _LicencePageState();
}

class _LicencePageState extends State<LicencePage> {
  final _licenceKeyTextController = TextEditingController();
  StreamSubscription<LicenceFormState>? subscription;

  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    context.read<NotificationCubit>().reset();

    subscription =
        context.read<LicenceFormCubit>().stream.listen(listenLicenceCubit);
  }

  void listenLicenceCubit(state) {
    setState(() {
      if (state is LicenceSubmitting) {
        isSubmitting = true;
      } else {
        isSubmitting = false;
      }
    });
  }

  void onSave() {
    context.read<LicenceFormCubit>().submit(_licenceKeyTextController.text);
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RotatedBox(
                quarterTurns: 1,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.orange[50],
                  ),
                  child: const Icon(
                    Icons.key,
                    color: Colors.orange,
                    size: 50,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Merci d'introduire la clé de licence fournie",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _licenceKeyTextController,
                decoration: AppInputDecoration(),
              ),
              const SizedBox(height: 20),
              const NotificationWidget(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                onPressed: isSubmitting ? null : onSave,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Text(
                      'Confirmer',
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
          ),
        ),
      ),
    );
  }
}
