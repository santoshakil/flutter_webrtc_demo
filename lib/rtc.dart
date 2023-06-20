import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:http/http.dart';

class PeerConnection {
  late RTCPeerConnection _peerConnection;
  late RTCDataChannel _dataChannel;

  Future<void> initPeer() async {
    _peerConnection = await createPeerConnection({
      'iceServers': [
        {'url': 'stun:stun.l.google.com:19302'},
      ]
    }, {});

    _dataChannel = await _peerConnection.createDataChannel('data', RTCDataChannelInit());
  }

  Future<RTCSessionDescription> createOffer() async {
    final offer = await _peerConnection.createOffer({});
    await _peerConnection.setLocalDescription(offer);
    await postSDP(offer.sdp!);
    return offer;
  }

  Future<RTCSessionDescription> createAnswer() async {
    final sdp = await getSDP();
    final offer = RTCSessionDescription(sdp!, 'answer');
    await _peerConnection.setRemoteDescription(offer);
    final answer = await _peerConnection.createAnswer({});
    await _peerConnection.setLocalDescription(answer);
    return answer;
  }

  void sendMessage(String message) {
    if (_dataChannel.state == RTCDataChannelState.RTCDataChannelOpen) {
      _dataChannel.send(RTCDataChannelMessage(message));
    }
  }
}

Future<void> postSDP(String sdp) async {
  try {
    final url = Uri.parse('http://0.0.0.0:8080/post');
    await post(url, body: sdp);
    debugPrint('Posted');
  } catch (e) {
    debugPrint(e.toString());
  }
}

Future<String?> getSDP() async {
  try {
    final url = Uri.parse('http://0.0.0.0:8080/get');
    final response = await get(url);
    debugPrint('Got: ${response.body}');
    return response.body;
  } catch (e) {
    debugPrint(e.toString());
  }
  return null;
}
