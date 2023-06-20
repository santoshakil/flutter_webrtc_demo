import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_webrtc_demo/rtc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MainApp()));
}

PeerConnection? peer;

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              child: const Text('Offer'),
              onPressed: () async {
                peer = PeerConnection();
                await peer!.initPeer();
                await peer!.createOffer();
                peer!.sendMessage('Hello');
              },
            ),
            ElevatedButton(
              child: const Text('Answer'),
              onPressed: () async {
                peer = PeerConnection();
                await peer!.initPeer();
                await peer!.createAnswer();
              },
            ),
            ElevatedButton(
              child: const Text('Send'),
              onPressed: () async {
                peer?.sendMessage('Hello');
              },
            ),
          ],
        ),
      ),
    );
  }
}
