import 'dart:async';
import 'dart:io';

import 'package:another_audio_recorder/another_audio_recorder.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:path_provider/path_provider.dart';


class AudioRecorde extends StatefulWidget {
  final LocalFileSystem localFileSystem;

  AudioRecorde({localFileSystem})
      : this.localFileSystem = localFileSystem ?? LocalFileSystem();

  @override
  State<StatefulWidget> createState() => new AudioRecordeState();
}

class AudioRecordeState extends State<AudioRecorde> {
  FlutterAudioRecorder _recorder;
  Recording _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;
  bool btnvisbl = true;
  late String lastpath;

  @override
  void initState() {
    _init();
    print("AudioRecorde page");
    // TODO: implement initState
    super.initState();
  }


  song() async {
    print("asdfs" +lastpath.toString());
    AudioPlayer audioPlayer = AudioPlayer();
    int result = await audioPlayer.play("$lastpath", isLocal: true);
    if (result == 1) {
      // success
      print("success");
    }else{
      print("nooo");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(190.0),
          child: Container(
            height: 80,
            decoration: BoxDecoration(
                gradient: new LinearGradient(
                    colors: [Color(0xFFE7E9EE), Color(0xFF328BF6)],
                    begin: FractionalOffset.centerLeft,
                    end: FractionalOffset.centerRight,
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp)),
            width: double.maxFinite,
            child: Padding(
              padding: const EdgeInsets.only(
                  //  bottom: 1,
                  right: 10,
                  left: 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: () {
                          print("hi");
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          // fit: StackFit.expand,
                          children: [
                            Center(
                              child: Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40.0),
                                    image: DecorationImage(
                                        image: AssetImage("assets/icon1.jpg"),
                                        fit: BoxFit.fill)),
                                margin: new EdgeInsets.only(
                                    left: 0.0,
                                    top: 5.0,
                                    right: 0.0,
                                    bottom: 0.0),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Center(
                                    child: Text(
                                      "",
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.red),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        )),
                    GestureDetector(
                      onTap: () {
                        print("hi");
                      },
                      child: Container(
                          margin: EdgeInsets.only(top: 10, bottom: 15),
                          child: Column(children: [
                            SizedBox(
                              height: 7,
                            ),
                            Expanded(
                              child: Text(
                                // "Shop Visited",
                                "INDEX",
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 7),
                                child: Text(
                                  "${"branchName".toString()}",
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.white),
                                ),
                              ),
                            ),
                          ])),
                    ),
                    GestureDetector(
                      onTap: () {
                        Widget noButton = TextButton(
                          child: Text("No"),
                          onPressed: () {
                            setState(() {
                              print("No...");
                              Navigator.pop(
                                  context); // this is proper..it will only pop the dialog which is again a screen
                            });
                          },
                        );

                        Widget yesButton = TextButton(
                          child: Text("Yes"),
                          onPressed: () {
                            setState(() {
                              print("yes...");
                            //  pref.remove('userData');
                              Navigator.pop(context); //okk
//                              Navigator.pop(context);
                              Navigator.pushReplacementNamed(
                                  context, "/logout");

//                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()),);
                            });
                          },
                        );
                        showDialog(
                            context: context,
                            builder: (c) => AlertDialog(
                                content: Text("Do you really want to logout?"),
                                actions: [yesButton, noButton]));
                      },
                      child: Container(
                        margin: new EdgeInsets.only(
                            left: 0.0, top: 25.0, right: 0.0, bottom: 0.0),
                        child: Text(
                          "${"userName".toString()}",
                          style: TextStyle(fontSize: 13, color: Colors.white),
                        ),
                      ),
                    )
                  ]),
            ),
          ),
        ),
        body: ListView(
              physics:  NeverScrollableScrollPhysics(),
            children: [
          Container(
          height:  MediaQuery.of(context).size.height,

            decoration: BoxDecoration(
              image: DecorationImage(
                //  NetworkImage("https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww."
                //     "hockaik.org%2F2021%2F04%2Fhow-to-create-backdrop-blurred-image.html&psig"
                //     "=AOvVaw3LTV0Era0LkLKGCJ3U4Fjk&ust=1620371007632000&source=images&cd=vfe"
                //     "&ved=0CAIQjRxqFwoTCIi45oq_tPACFQAAAAAdAAAAABAF"),

                image:   NetworkImage("https://www.impactbnd.com/hubfs/Marketing_Sales_integration-2.png"),
                fit:  BoxFit.cover,),

            ),




          // color: Colors.white,
          child: new Padding(
            padding: new EdgeInsets.all(8.0),
            child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: new TextButton(
                          onPressed: () {
                            switch (_currentStatus) {
                              case RecordingStatus.Initialized:
                                {
                                  _start();
                                  break;
                                }
                              case RecordingStatus.Recording:
                                {
                                  _pause();
                                  break;
                                }
                              case RecordingStatus.Paused:
                                {
                                  _resume();
                                  break;
                                }
                              case RecordingStatus.Stopped:
                                {
                                  _init();
                                  break;
                                }
                              default:
                                break;
                            }
                          },
                          child: _buildText(_currentStatus),
                          // color: Colors.lightBlue,
                        ),
                      ),
                      Visibility(
                        visible: btnvisbl,
                        child: new TextButton(
                          onPressed: _currentStatus != RecordingStatus.Unset ? _stop : null,
                          child: Text("Stop", style: TextStyle(color: Colors.white)),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.blueAccent.withOpacity(0.5)),
                          ),
                        )

                      ),
                      SizedBox(
                        width: 8,
                      ),
                      new TextButton(
                        onPressed: onPlayAudio,
                        child: Text("Play", style: TextStyle(color: Colors.white)),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.green.withOpacity(0.5)),
                        ),
                      ),


                      SizedBox(
                        width: 8,
                      ),


                    ],
                  ),
                  // FlatButton(
                  //   onPressed: song,
                  //   child:
                  //   new Text("Play 3", style: TextStyle(color: Colors.white)),
                  //   color: Colors.blueAccent.withOpacity(0.5),
                  // ),
                ]),
          ),
        ),

        ]),
      ),
    );
  }

  _init() async {
    try {
      if (await FlutterAudioRecorder.hasPermissions) {
        String customPath = 'Qizo_audio_recorder_';
        dynamic appDocDirectory;
//        io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
        if (Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
          print("1" + appDocDirectory.path);
        } else {
          appDocDirectory = await getExternalStorageDirectory();
          print("2" + appDocDirectory.path);
        }

        // can add extension like ".mp4" ".wav" ".m4a" ".aac"
        customPath = appDocDirectory.path +
            customPath +
            DateTime.now().millisecondsSinceEpoch.toString();

        print("3 : $customPath");
        // .wav <---> AudioFormat.WAV
        // .mp4 .m4a .aac <---> AudioFormat.AAC
        // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
        _recorder =
            FlutterAudioRecorder(customPath, audioFormat: AudioFormat.AAC);

        await _recorder.initialized;
        // after initialization
        var current = await _recorder.current(channel: 0);
        print("current: $current");
        // should be "Initialized", if all working fine
        setState(() {
          _current = current;
          _currentStatus = current.status;
          print("_currentStatus: $_currentStatus");
          btnvisbl = false;
        });
      } else {
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: new Text("You must accept permissions")));
      }
    } catch (e) {
      print("_init error 1: $e");
    }
  }

  _start() async {
    try {
      await _recorder.start();
      var recording = await _recorder.current(channel: 0);
      setState(() {
        _current = recording;
      });

      const tick = const Duration(milliseconds: 50);
      new Timer.periodic(tick, (Timer t) async {
        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }

        var current = await _recorder.current(channel: 0);
        // print(current.status);
        setState(() {
          _current = current;
          _currentStatus = _current.status!;
          btnvisbl = true;
        });
      });
    } catch (e) {
      print("_start error 2: $e");
    }
  }

  _resume() async {
    await _recorder.resume();
    setState(() {});
  }

  _pause() async {
    await _recorder.pause();
    setState(() {});
  }

  _stop() async {
    var result = await _recorder.stop();
    print("Stop recording: ${result.path}");
    print("Stop recording: ${result.duration}");
    File file = widget.localFileSystem.file(result.path);
    print("File length: ${await file.length()}");
    setState(() {
      _current = result;
      _currentStatus = _current.status!;
      btnvisbl = false;
    });
  }

  Widget _buildText(RecordingStatus status) {
    var text = "";
    switch (_currentStatus) {
      case RecordingStatus.Initialized:
        {
          text = 'Start';
          break;
        }
      case RecordingStatus.Recording:
        {
          text = 'Pause';
          break;
        }
      case RecordingStatus.Paused:
        {
          text = 'Resume';
          break;
        }
      case RecordingStatus.Stopped:
        {
          text = 'New';
          break;
        }
      default:
        break;
    }
    return Text(text, style: TextStyle(color: Colors.white));
  }

  void onPlayAudio() async {
    try {
      print("asdfs" + _current.path);
      AudioPlayer audioPlayer = AudioPlayer();
      await audioPlayer.play(_current.path, isLocal: true);
      //  await audioPlayer.play("/storage/emulated/0/Android/data/com.example.ErpAapp/filesQizo_audio_recorder_1619002226901.m4a",isLocal: true);
    } catch (e) {
      print("dfhfgdh$e");
    }
  }
}
