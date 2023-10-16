import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  File? file;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (file != null) {
          file = null;
          setState(() {});
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: file == null
            ? SmartFaceCamera(
                onCapture: (e) {
                  file = e;
                  setState(() {});
                },
                autoCapture: true,
                message: "Tolong ditengah",
                defaultCameraLens: CameraLens.front,
              )
            : Stack(
                children: [
                  Image.file(
                    file!,
                    height: MediaQuery.of(context).size.height,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: InkWell(
                      onTap: () async {
                        var download = await getExternalStorageDirectory();
                        print(download!.path);
                        var file = File(
                          path.join(
                              download.path, path.basename(this.file!.path)),
                        );
                        await file.writeAsBytes(
                            this.file!.readAsBytesSync().toList());
                        this.file = null;
                        setState(() {});
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Image has been save"),
                            ),
                          );
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(
                          right: 15,
                          bottom: 15,
                        ),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
