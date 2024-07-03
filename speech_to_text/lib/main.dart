import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speech/flutter_speech.dart';

void main() {
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  runApp(MyApp());
}

const languages = const [
  const Language('English', 'en_US'),
];

class Language {
  final String name;
  final String code;

  const Language(this.name, this.code);
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late SpeechRecognition _speech;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;

  String transcription = '';

  String _currentLocale = 'en_US';
  Language selectedLang = languages.first;

  @override
  initState() {
    super.initState();
    activateSpeechRecognizer();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('_MyAppState.activateSpeechRecognizer... ');
    _speech = SpeechRecognition();
    _speech.setAvailabilityHandler(onSpeechAvailability);
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech.setErrorHandler(errorHandler);
    _speech.activate('en_US').then((res) {
      setState(() => _speechRecognitionAvailable = res);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('SpeechRecognition'),
        ),
        body: Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                      Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(transcription)
                          ), 
                      Spacer(),
                      FloatingActionButton.large(
                         backgroundColor: Colors.blue,
                         
                         onPressed: _speechRecognitionAvailable && !_isListening
                        ? () => start()
                        : null,
                          child: Icon(
                            Icons.mic,
                            size: 50,
                            color: Colors.white,
                         ),
                        ),
                        Spacer(),
                  _buildButton(
                    onPressed: _isListening ? () => cancel() : null,
                    label: 'Cancel',
                  ),
                  _buildButton(
                    onPressed: _isListening ? () => stop() : null,
                    label: 'Stop',
                  ),
                ],
              ),
            )),
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.bluetooth),
                  label: 'Bluetooth',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.mic),
                  label: 'Mic',
                ),
             ],
           ),
      ),
    );
  }
  Widget _buildButton({required String label, VoidCallback? onPressed}) => Padding(
      padding: EdgeInsets.all(12.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ));

  void start() => _speech.activate(selectedLang.code).then((_) {
        return _speech.listen().then((result) {
          print('_MyAppState.start => result $result');
          setState(() {
            _isListening = result;
          });
        });
      });

  void cancel() =>
      _speech.cancel().then((_) => setState(() => _isListening = false));

  void stop() => _speech.stop().then((_) {
        setState(() => _isListening = false);
      });

  void onSpeechAvailability(bool result) =>
      setState(() => _speechRecognitionAvailable = result);

  void onCurrentLocale(String locale) {
    print('_MyAppState.onCurrentLocale... $locale');
    setState(
        () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() {
    setState(() => _isListening = true);
  }

  void onRecognitionResult(String text) {
   print('_MyAppState.onRecognitionResult... $text');
    setState(() => transcription = setTranscription(text));
  }

  void onRecognitionComplete(String text) {
    print('_MyAppState.onRecognitionComplete... $text');
    setState(() => _isListening = false);
  }

  void errorHandler() => activateSpeechRecognizer();
}

  String setTranscription(String text) {
    text.toLowerCase();
    if(text.contains("right")){
      return "The wheelchair is turning right";
    }
    else if(text.contains("left")){
      return "The wheelchair is turning left";
    }
    else if(text.contains("forward")){
      return "The wheelchair is moving forward";
    }
    else if(text.contains("backward")){
      return "The wheelchair is moving backwards";
    }
    else if(text.contains("stop")){
      return "The wheelchair stopped";
    }
    return "Unrecognized";
  }
