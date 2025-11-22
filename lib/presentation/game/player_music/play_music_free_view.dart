// import 'package:flutter/material.dart';
// import 'package:spotify_sdk/models/player_state.dart';
// import 'package:just_audio/just_audio.dart';

// class PlayerMusicFreeView extends StatefulWidget {
//   final String previewUrl; // URL de 30s da Web API

//   const PlayerMusicFreeView({super.key, required this.previewUrl});

//   @override
//   State<PlayerMusicFreeView> createState() => _PlayerMusicFreeViewState();
// }

// class _PlayerMusicFreeViewState extends State<PlayerMusicFreeView> {
//   final AudioPlayer _player = AudioPlayer();

//   bool _isLoading = true;
//   String? _error;

//   @override
//   void initState() {
//     super.initState();
//     _initPlayer();
//   }

//   Future<void> _initPlayer() async {
//     try {
//       await _player.setUrl(widget.previewUrl);
//       setState(() => _isLoading = false);
//       _player.play(); // começa a tocar automaticamente
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//         _error = 'Não foi possível carregar a prévia de 30 segundos.';
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _player.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     }

//     if (_error != null) {
//       return Scaffold(
//         body: Center(
//           child: Padding(
//             padding: const EdgeInsets.all(24.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Icon(Icons.error_outline, color: Colors.red, size: 48),
//                 const SizedBox(height: 16),
//                 Text(
//                   _error!,
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(fontSize: 16),
//                 ),
//                 const SizedBox(height: 24),
//                 ElevatedButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: const Text('Voltar'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     }

//     return Scaffold(
//       body: Center(
//         child: StreamBuilder<PlayerState>(
//           stream: _player.playerStateStream,
//           builder: (context, snapshot) {
//             final state = snapshot.data;
//             final playing = state?.playing ?? false;

//             return GestureDetector(
//               onTap: () => playing ? _player.pause() : _player.play(),
//               child: Container(
//                 width: 220,
//                 height: 220,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   gradient: const LinearGradient(
//                     colors: [Color(0xFF7BE495), Color(0xFF5EC5FF)],
//                     begin: Alignment.topRight,
//                     end: Alignment.bottomLeft,
//                   ),
//                   boxShadow: const [
//                     BoxShadow(blurRadius: 24, color: Colors.black26),
//                   ],
//                 ),
//                 child: Icon(
//                   playing ? Icons.pause : Icons.play_arrow,
//                   size: 120,
//                   color: Colors.white,
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
