import 'dart:io';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:socketio_chat_app/Screens/camera_view.dart';

List<CameraDescription> cameras;

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key key, this.onImageSend}) : super(key: key);
  final Function onImageSend;

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {

  CameraController _cameraController;

  Future<void> cameraValue;

  bool isRecording = false;

  bool flash = false;

  bool isCameraFront = true;

  double transform = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cameraController = CameraController(cameras[0], ResolutionPreset.high);
    cameraValue = _cameraController.initialize();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _cameraController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          FutureBuilder(
            future: cameraValue,
            builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.done){
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: CameraPreview(_cameraController));
              }
              else{
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }
          ),

          Positioned(
            bottom: 0.0,
            child: Container(
              color: Colors.black,
              padding: EdgeInsets.only(top: 5, bottom: 5),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon( flash ? Icons.flash_on : Icons.flash_off,
                          color: Colors.white,
                        size: 28,),
                        onPressed: () {
                          setState(() {
                            flash = !flash;
                          });
                          flash ? _cameraController.setFlashMode(FlashMode.torch) :
                                  _cameraController.setFlashMode(FlashMode.off);
                        },
                      ),
                     GestureDetector(
                       onLongPress: () async{
                         await _cameraController.startVideoRecording();
                         setState(() {
                           isRecording = true;
                         });
                       },

                       onTap: () {
                         if(!isRecording)
                         takePhoto(context);
                       },
                       child: Icon(Icons.panorama_fish_eye,
                           color: Colors.white,
                           size: 70),
                     ),
                      IconButton(
                        icon: Transform.rotate(
                          angle: transform,
                          child: Icon(Icons.flip_camera_ios,
                            color: Colors.white,
                            size: 28,),
                        ),
                        onPressed: () async{
                          setState(() {
                            isCameraFront = !isCameraFront;
                            transform = transform + pi;
                          });
                          int camerapos = isCameraFront ? 0 : 1;
                          _cameraController = CameraController(
                              cameras[camerapos], ResolutionPreset.high);
                          cameraValue = _cameraController.initialize();
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text("Tap for photo", style: TextStyle(
                    color: Colors.white
                  ), textAlign: TextAlign.center,)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void takePhoto(context) async{

    final path = await _cameraController.takePicture();
    Navigator.push(context, MaterialPageRoute(builder: (builder) => CameraViewPage(
      path: path.path,
    onSend: widget.onImageSend,)));

  }
}
