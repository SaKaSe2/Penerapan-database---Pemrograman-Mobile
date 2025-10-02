import 'package:flutter/material.dart';

// halaman sederhana untuk ilustrasi (stateless/stateful)
import 'stateless_voting.dart';
import 'stateful_voting.dart';

// halaman baru: stateful + persistent
import 'persistent_stateful_voting.dart';

// halaman baru: stateful (optimistic + undo) — dulu provider, sekarang stateful
import 'provider_stateful_voting.dart';

void main() => runApp(const VotingApp());

class VotingApp extends StatelessWidget {
  const VotingApp({super.key});

  // contoh data - setiap item punya id unik (penting untuk Key)
  List<Map<String, dynamic>> sampleApps() => [
        {'id': 'a1', 'name': 'MobileLegends', 'desc': 'Game Ramah', 'likes': 0, 'dislikes': 0},
        {'id': 'a2', 'name': 'HonorOfKings', 'desc': 'Game Bagus', 'likes': 0, 'dislikes': 0},
        {'id': 'a3', 'name': 'WhatsApp', 'desc': 'Aplikasi Chatting', 'likes': 0, 'dislikes': 0},
        {'id': 'a4', 'name': 'Facebook', 'desc': 'Aplikasi Terbaik', 'likes': 0, 'dislikes': 0},
        {'id': 'a5', 'name': 'Roblox', 'desc': 'Sangat Ramah', 'likes': 0, 'dislikes': 0},
        {'id': 'a6', 'name': 'PUBG', 'desc': 'Game Terlaris', 'likes': 0, 'dislikes': 0},
        {'id': 'a7', 'name': 'MagicChess', 'desc': 'Game Ngantuk', 'likes': 0, 'dislikes': 0},
        {'id': 'a8', 'name': 'Bybit', 'desc': 'Terbaik', 'likes': 0, 'dislikes': 0},
        {'id': 'a9', 'name': 'Pou', 'desc': 'Merawat Hewan', 'likes': 0, 'dislikes': 0},
        {'id': 'a10', 'name': 'Instagram', 'desc': 'Media Sosial', 'likes': 0, 'dislikes': 0},
      ];

  @override
  Widget build(BuildContext context) {
    final apps = sampleApps();
    return MaterialApp(
      title: 'Voting P2 Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(apps: apps),
    );
  }
}

class HomePage extends StatelessWidget {
  final List<Map<String, dynamic>> apps;
  const HomePage({super.key, required this.apps});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voting: Pilih Versi (Modul P2)')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Pilih versi untuk eksperimen:'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => StatelessVotingPage(items: apps)));
              },
              child: const Text('Stateless Version (ilustrasi Modul P2)'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => StatefulVotingPage(items: apps)));
              },
              child: const Text('Stateful Version (sederhana)'),
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                // persistent version (stateful + SharedPreferences)
                Navigator.push(context, MaterialPageRoute(builder: (_) => PersistentStatefulVotingPage(initialItems: apps)));
              },
              child: const Text('Persistent (Stateful + SharedPreferences)'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                // provider-like behaviour but implemented inside stateful widget (optimistic + undo)
                Navigator.push(context, MaterialPageRoute(builder: (_) => ProviderStatefulVotingPage(initialItems: apps)));
              },
              child: const Text('Provider-style (Stateful: Optimistic + Undo)'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Instruksi singkat:\n- Stateless: ubah model tapi UI tidak otomatis.\n- Stateful: UI update via setState().\n- Persistent: tersimpan antara run app.\n- Provider-style: optimistic update + Undo (simulasi network).',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}