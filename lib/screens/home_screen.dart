import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Map<String, HighlightedWord> _highlights = {
    'Paula': HighlightedWord(
      onTap: () => print('oi amor'),
      textStyle: TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      )
    )
  };

  SpeechToText _speech;
  bool _isListening = false;
  String _text = "Press the button and start speaking";
  double _confidence = 1.0;


  @override
  void initState() {
    super.initState();
    _speech = SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Confidence: ${(_confidence *100.0).toStringAsFixed(1)}%"),
        centerTitle: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Colors.red,
        endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          onPressed: _listen,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
          backgroundColor: Colors.red,
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: EdgeInsets.fromLTRB(30, 30, 30, 150),
          child: TextHighlight(
            text: _text,
            words: _highlights,
            textStyle: TextStyle(
              fontSize: 32,
              color: Colors.black,
              fontWeight: FontWeight.w400
            ),
          ),
        ),
      ),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print("onStatus: ${val}"),
        onError: (val) => print('onError: ${val}'),
      );
      if (available) {
        setState(() {
          _isListening = true;
        });

        _speech.listen(
          onResult: (val) {
            setState(() {
              _text = val.recognizedWords;
              if(val.hasConfidenceRating && val.confidence > 0) {
                _confidence = val.confidence;
              }
            });
          }
        );
      }
    }
    else {
      setState(() {
        _isListening = false;
      });

      _speech.stop();
    }
  }
}
