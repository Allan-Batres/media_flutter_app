import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({Key? key}) : super(key: key);

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  int maxduration = 100;
  int currentpos = 0;
  String currentpostlabel = "00:00";
  String audioasset = "assets/music/Admirable.mp3";
  bool isplaying = false;
  bool audioplayed = false;
  late Uint8List audiobytes;

  AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      ByteData bytes =
          await rootBundle.load(audioasset); //load audio from assets
      audiobytes =
          bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);

      player.onDurationChanged.listen((Duration d) {
        maxduration = d.inMilliseconds;
        setState(() {});
      });

      player.onAudioPositionChanged.listen((Duration p) {
        currentpos =
            p.inMilliseconds; 

        //generating the duration label
        int shours = Duration(milliseconds: currentpos).inHours;
        int sminutes = Duration(milliseconds: currentpos).inMinutes;
        int sseconds = Duration(milliseconds: currentpos).inSeconds;

        int rhours = shours;
        int rminutes = sminutes - (shours * 60);
        int rseconds = sseconds - (sminutes * 60 + shours * 60 * 60);

        currentpostlabel = "$rhours:$rminutes:$rseconds";

        setState(() {
          //refresh the UI
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/Admirable.jpeg'),
                  fit: BoxFit.cover),
            ),
          ),
          const SizedBox(
            height: 500,
          ),
          const Padding(
            padding: EdgeInsets.only(
              top: 100,
            ),
            child: Center(
              child: Text(
                "Admirable | Christine D'clario | Julio Melgar | Emanuel",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 500, left: 10, right: 10),
            child: SizedBox(
              height: 200,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: Colors.black.withOpacity(0.2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          iconSize: 50,
                          icon: Icon(isplaying ? Icons.pause : Icons.play_arrow),
                          onPressed: () async {
                            if (!isplaying && !audioplayed) {
                              int result = await player.playBytes(audiobytes);
                              if (result == 1) {
                                //play success
                                setState(() {
                                  isplaying = true;
                                  audioplayed = true;
                                });
                              } else {
                                debugPrint("Error while playing audio.");
                              }
                            } else if (audioplayed && !isplaying) {
                              int result = await player.resume();
                              if (result == 1) {
                                //resume success
                                setState(() {
                                  isplaying = true;
                                  audioplayed = true;
                                });
                              } else {
                                debugPrint("Error on resume audio.");
                              }
                            } else {
                              int result = await player.pause();
                              if (result == 1) {
                                //pause success
                                setState(() {
                                  isplaying = false;
                                });
                              } else {
                                debugPrint("Error on pause audio.");
                              }
                            }
                          },
                        ),
                        Slider(
                            activeColor: Colors.amberAccent,
                            value: double.parse(currentpos.toString()),
                            min: 0,
                            max: double.parse(maxduration.toString()),
                            divisions: maxduration,
                            label: currentpostlabel,
                            onChanged: (double value) async {
                               int seekval = value.round();
                               int result = await player.seek(Duration(milliseconds: seekval));
                               if(result == 1){ //seek successful
                                    currentpos = seekval;
                               }else{
                                    debugPrint("Seek unsuccessful.");
                               }
                            },
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(currentpostlabel)
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
