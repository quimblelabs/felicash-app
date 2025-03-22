import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class CreateWalletModal extends StatelessWidget {
  const CreateWalletModal({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppBorderRadius.xlg),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Wallet'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: const Center(
          child: Text('Create Wallet'),
        ),
      ),
    );
  }
}
