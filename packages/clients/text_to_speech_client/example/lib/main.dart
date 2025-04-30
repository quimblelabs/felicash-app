import 'package:flutter/material.dart';
import 'package:text_to_speech_client/text_to_speech_client.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final ElevenLabsTextToSpeechClient _textToSpeechClient;

  @override
  void initState() {
    _textToSpeechClient = ElevenLabsTextToSpeechClient(
      apiKey: 'ELEVENLABS_API_KEY',
      baseUrl: 'ELEVENLABS_BASE_URL',
      enableDebug: true,
    );
    super.initState();
  }

  Future<void> _speak() async {
    await _textToSpeechClient.speak(
      'Xin chào bạn, hôm nay bạn khoẻ không?',
      voice: TTSElevenLabsVoice.tvcAiHanh,
      model: TTSElevenLabsModel.elevenTurboV25,
    );
    await _textToSpeechClient.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: FilledButton(
                onPressed: _speak,
                child: const Text('Speak'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
