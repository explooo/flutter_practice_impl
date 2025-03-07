import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'webrtc_service.dart';

class VideoCallScreen extends StatefulWidget {
  @override
  _VideoCallScreenState createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  final WebRTCService _webrtcService = WebRTCService();
  final TextEditingController _callIdController = TextEditingController();
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();

  @override
  void initState() {
    super.initState();
    _initializeWebRTC();
  }

  void disposeRenderers() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
  }

  @override
  void dispose() {
    _webrtcService.closeConnection();
    disposeRenderers();
    super.dispose();
  }

  Future<void> _initializeWebRTC() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
    await _webrtcService.initWebRTC();

    setState(() {
      _localRenderer.srcObject = _webrtcService.getLocalStream();
    });

    _webrtcService.onRemoteStreamUpdate = (stream) {
      if (mounted) {
        setState(() {
          _remoteRenderer.srcObject = stream;
        });
      }
    };
  }

  void _startCall() async {
    await _webrtcService.createCall();
    setState(() {
      _callIdController.text = _webrtcService.callId!;
    });
  }

  void _joinCall() async {
    await _webrtcService.joinCall(_callIdController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Video Chat")),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: RTCVideoView(_localRenderer, mirror: true)),
            Expanded(
              child:
                  _remoteRenderer.srcObject == null
                      ? Center(child: Text("Waiting for participant"))
                      : RTCVideoView(_remoteRenderer),
            ),
            TextField(
              controller: _callIdController,
              decoration: InputDecoration(labelText: "Enter Call ID"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _startCall,
                  child: Text("Start Call"),
                ),
                SizedBox(width: 10),
                ElevatedButton(onPressed: _joinCall, child: Text("Join Call")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
