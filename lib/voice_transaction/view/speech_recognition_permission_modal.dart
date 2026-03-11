import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:permission_client/permission_client.dart';

class SpeechRecognitionPermissionModal extends StatefulWidget {
  const SpeechRecognitionPermissionModal({super.key});

  @override
  State<SpeechRecognitionPermissionModal> createState() =>
      _SpeechRecognitionPermissionModalState();
}

class _SpeechRecognitionPermissionModalState
    extends State<SpeechRecognitionPermissionModal> {
  final _permissionClient = const PermissionClient();
  PermissionStatus _micPermission = PermissionStatus.denied;
  PermissionStatus _speechRecognitionPermission = PermissionStatus.denied;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final micPermission = await _permissionClient.microphoneStatus();
    final speechRecognitionPermission =
        await _permissionClient.speechRecognitionStatus();
    setState(() {
      _micPermission = micPermission;
      _speechRecognitionPermission = speechRecognitionPermission;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ModalScaffold(
      content: ListTileTheme(
        tileColor: theme.colorScheme.surfaceContainerLowest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            spacing: AppSpacing.md,
            children: [
              Text(
                'Speech Recognition Permission',
                style: theme.textTheme.headlineSmall,
              ),
              Text(
                'To use voice input, please grant permission '
                'to use your microphone.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              ListTile(
                onTap: () async {
                  await _permissionClient.requestMicrophone();
                  await _checkPermission();
                },
                leading: const Icon(Icons.mic),
                title: const Text('Microphone'),
                subtitle: const Text(
                  'Allow to use your microphone for voice input.',
                ),
                trailing: _micPermission.isGranted
                    ? const Icon(Icons.check)
                    : Text(
                        'Not granted',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                      ),
              ),
              ListTile(
                onTap: () async {
                  await _permissionClient.requestSpeechRecognition();
                  await _checkPermission();
                },
                leading: const Icon(Icons.mic),
                title: const Text('Speech Recognition'),
                subtitle: const Text(
                  'Allow Speech Recognition to use your microphone to transcribe your voice.',
                ),
                trailing: _speechRecognitionPermission.isGranted
                    ? const Icon(Icons.check)
                    : Text(
                        'Not granted',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
