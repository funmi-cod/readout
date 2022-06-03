import 'dart:async';
import 'dart:io';


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:readout/model/pdf_api.dart';
import 'package:readout/view/pdf_viewer_screen.dart';
import 'package:readout/widgets/default_divider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isPlaying = false;
  // Create an Instance flutterTts
   late FlutterTts flutterTts;
  //
  // _speak(String text) async {
  //   //print('Hello');
  //   await flutterTts.setLanguage("en-US");
  //   print('Hello');
  //   await flutterTts.setPitch(1.0); // varies from 0.5 to 1.5
  //   await flutterTts.speak(text);
  // }
  initializeTts() {

     flutterTts = FlutterTts();

    flutterTts.setStartHandler(() {
      setState(() {
        isPlaying = true;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        isPlaying = false;
      });
    });

    flutterTts.setErrorHandler((err) {
      setState(() {
        print("Error occurred: " + err);
        isPlaying = false;
      });
    });
  }

  void setTtsLanguage() async {
    await flutterTts.setLanguage("en-US");
  }

  void speechSettings() {
    flutterTts.setVoice({"name": "Maria", "locale": "en-US"});
    flutterTts.setPitch(1.5);
    flutterTts.setSpeechRate(.9);
  }
  
  Future _speak(String text) async {
    if (text.isNotEmpty) {
      var result = await flutterTts.speak(text);
      if (result == true) {
        setState(() {
          isPlaying = true;
        });
      }
    }
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) {
      setState(() {
        isPlaying = false;
      });
    }
  }

  //  generate List of random colors for the gradient
  List<Color> get getColors => [
        const Color(0xff006E7f),
        const Color(0xffee5007),
        const Color(0xffffffff),
        const Color(0xffb22700),
        const Color(0xfff8cb2e),
      ]..shuffle();

  // generate list of alignment to set gradient start and end
  // for random color animation

  List<Alignment> get getAlignments => [
        Alignment.topRight,
        Alignment.topLeft,
        Alignment.bottomLeft,
        Alignment.bottomRight
      ];

  // This will be used to get the correct alignment of the gradient
  var counter = 0;

  // Create timer to animate the gradient every 5 seconds

  _bgColorAnimatedTimer() {
    // animating for the first time
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      counter++;
      setState(() {});
    });
    const interval = Duration(seconds: 5);
    Timer.periodic(interval, (Timer timer) {
      counter++;
      setState(() {});
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bgColorAnimatedTimer();
    initializeTts();
  }

  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var mainHeight = MediaQuery.of(context).size.height;
    var mainWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "PDF Reader",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.black87,
          foregroundColor: Colors.white70,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => isPlaying? _stop(): _speak(textEditingController.text),
          backgroundColor: Colors.black87,
          foregroundColor: Colors.white,
          child: Icon(
            isPlaying? Icons.stop: Icons.play_arrow,
            color: Colors.white,
          ),
        ),
        body: SafeArea(
          child: Container(
            //color: Colors.white70,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Stack(
                children: [
                  AnimatedContainer(
                      height: mainHeight,
                      width: mainWidth,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin:
                                  getAlignments[counter % getAlignments.length],
                              end: getAlignments[
                                  (counter + 2) % getAlignments.length],
                              colors: getColors,
                              tileMode: TileMode.clamp)),
                      duration: const Duration(seconds: 4)),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                    child: Container(
                      height: 500,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        //color: Colors.white
                      ),
                      child: TextFormField(
                        controller: textEditingController,
                        decoration: InputDecoration(
                            fillColor: Colors.black87,
                            labelText: 'Enter text here',
                            labelStyle: const TextStyle(
                                color: Colors.black87, fontSize: 10),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.black26,
                                )),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black87,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            )),
                      ),
                    ),
                  ),
                  const Positioned(
                    top: 260,
                    left: 30,
                    child: DefaultDivider(text: 'OR',),
                  ),
                  Positioned(
                    top: 330,
                    left: 100,
                    child: SizedBox(
                      height: 40,
                      width: 200,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.black87,
                            onPrimary: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () async {
                          final file = await PDFApi.pickFile();

                          // if user cancel picking files
                          if (file == null) return;

                          openPDF(context, file);
                        },
                        child:  Text(
                          "Pick PDF file",
                          style:GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  void openPDF(BuildContext context, File myFile) => Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => PDFViewerScreen(file:myFile)),);
}
