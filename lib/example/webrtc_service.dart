import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class WebRTCService {
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  MediaStream? _remoteStream;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? callId;
  Function(MediaStream?)? onRemoteStreamUpdate;
  void closeConnection() async {
    await _localStream?.dispose();
    await _remoteStream?.dispose();
    await _peerConnection?.close();
    _peerConnection = null;
  }

  Future<void> initWebRTC() async {
    _peerConnection = await createPeerConnection({
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ],
    });

    _localStream = await navigator.mediaDevices.getUserMedia({
      'video': true,
      'audio': true,
    });

    for (var track in _localStream!.getTracks()) {
      _peerConnection!.addTrack(track, _localStream!);
    }

    _peerConnection!.onTrack = (RTCTrackEvent event) {
      if (event.streams.isNotEmpty) {
        _remoteStream = event.streams[0];
        if (onRemoteStreamUpdate != null) {
          // 🔹 Call the callback
          onRemoteStreamUpdate!(_remoteStream);
        }
      }
    };

    _peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
      if (callId != null) {
        _firestore.collection('calls').doc(callId).update({
          'candidates': FieldValue.arrayUnion([
            jsonEncode({
              'candidate': candidate.candidate,
              'sdpMid': candidate.sdpMid,
              'sdpMLineIndex': candidate.sdpMLineIndex,
            }),
          ]),
        });
      }
    };
  }

  Future<void> createCall() async {
    callId = _firestore.collection('calls').doc().id;

    RTCSessionDescription offer = await _peerConnection!.createOffer();
    await _peerConnection!.setLocalDescription(offer);

    await _firestore.collection('calls').doc(callId).set({
      'offer': jsonEncode({'sdp': offer.sdp, 'type': offer.type}),
      'candidates': [],
    });

    _firestore.collection('calls').doc(callId).snapshots().listen((
      snapshot,
    ) async {
      if (snapshot.exists && snapshot.data()!.containsKey('answer')) {
        RTCSessionDescription answer = RTCSessionDescription(
          jsonDecode(snapshot['answer'])['sdp'],
          jsonDecode(snapshot['answer'])['type'],
        );
        await _peerConnection!.setRemoteDescription(answer);
      }
    });
  }

  Future<void> joinCall(String callId) async {
    this.callId = callId;

    DocumentSnapshot callDoc =
        await _firestore.collection('calls').doc(callId).get();
    if (callDoc.exists) {
      RTCSessionDescription offer = RTCSessionDescription(
        jsonDecode(callDoc['offer'])['sdp'],
        jsonDecode(callDoc['offer'])['type'],
      );

      if (_peerConnection!.signalingState !=
          RTCSignalingState.RTCSignalingStateHaveRemoteOffer) {
        await _peerConnection!.setRemoteDescription(offer);
      }

      if (_peerConnection!.signalingState ==
          RTCSignalingState.RTCSignalingStateHaveRemoteOffer) {
        RTCSessionDescription answer = await _peerConnection!.createAnswer();
        await _peerConnection!.setLocalDescription(answer);

        await _firestore.collection('calls').doc(callId).update({
          'answer': jsonEncode({'sdp': answer.sdp, 'type': answer.type}),
        });
      }

      _firestore.collection('calls').doc(callId).snapshots().listen((
        snapshot,
      ) async {
        if (snapshot.exists && snapshot.data()!.containsKey('candidates')) {
          List<dynamic> candidateList = snapshot['candidates'];
          for (var c in candidateList) {
            RTCIceCandidate candidate = RTCIceCandidate(
              jsonDecode(c)['candidate'],
              jsonDecode(c)['sdpMid'],
              jsonDecode(c)['sdpMLineIndex'],
            );
            await _peerConnection!.addCandidate(candidate);
          }
        }
      });
    }
  }

  MediaStream? getLocalStream() => _localStream;
  MediaStream? getRemoteStream() => _remoteStream;
}
