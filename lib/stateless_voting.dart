import 'package:flutter/material.dart';

class StatelessVotingPage extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  const StatelessVotingPage({super.key, required this.items});

  void _like(Map<String, dynamic> item) {
    // mengubah model (mutasi) tapi karena StatelessWidget tidak rebuild otomatis,
    // UI tidak akan berubah kecuali kita push halaman ulang.
    item['likes'] = (item['likes'] as int) + 1;
    debugPrint('[Stateless] ${item['name']} likes=${item['likes']}');
  }

  void _dislike(Map<String, dynamic> item) {
    item['dislikes'] = (item['dislikes'] as int) + 1;
    debugPrint('[Stateless] ${item['name']} dislikes=${item['dislikes']}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stateless (Modul P2)')),
      body: Column(
        children: [
          Container(
            color: Colors.yellow[100],
            padding: const EdgeInsets.all(8),
            child: const Text(
              'Stateless: menekan tombol mengubah data model tapi UI TIDAK otomatis update.\nCoba like lalu keluar dan kembali.',
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (ctx, idx) {
                final it = items[idx];
                return Card(
                  key: ValueKey(it['id'] ?? idx),
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(it['name']),
                    subtitle: Text(it['desc']),
                    trailing: SizedBox(
                      width: 140,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.thumb_up),
                            onPressed: () {
                              _like(it);
                              ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                                content: Text('Like registered for "${it['name']}" (UI not updated).'),
                                duration: const Duration(milliseconds: 700),
                              ));
                            },
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('L:${it['likes']}'),
                              Text('D:${it['dislikes']}'),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.thumb_down),
                            onPressed: () {
                              _dislike(it);
                              ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                                content: Text('Dislike registered for "${it['name']}" (UI not updated).'),
                                duration: const Duration(milliseconds: 700),
                              ));
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}