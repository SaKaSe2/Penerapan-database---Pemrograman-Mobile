import 'package:flutter/material.dart';

class StatefulVotingPage extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  const StatefulVotingPage({super.key, required this.items});

  @override
  State<StatefulVotingPage> createState() => _StatefulVotingPageState();
}

class _StatefulVotingPageState extends State<StatefulVotingPage> {
  late List<Map<String, dynamic>> items;

  @override
  void initState() {
    super.initState();
    // clone untuk mencegah mutasi list asli dari caller.
    items = widget.items.map((m) => Map<String, dynamic>.from(m)).toList();
  }

  void _like(int idx) {
    setState(() {
      items[idx]['likes'] = (items[idx]['likes'] as int) + 1;
    });
    debugPrint('[Stateful] ${items[idx]['name']} likes=${items[idx]['likes']}');
  }

  void _dislike(int idx) {
    setState(() {
      items[idx]['dislikes'] = (items[idx]['dislikes'] as int) + 1;
    });
    debugPrint('[Stateful] ${items[idx]['name']} dislikes=${items[idx]['dislikes']}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stateful (Modul P2)')),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
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
                    IconButton(icon: const Icon(Icons.thumb_up), onPressed: () => _like(idx)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('L:${it['likes']}'),
                        Text('D:${it['dislikes']}'),
                      ],
                    ),
                    IconButton(icon: const Icon(Icons.thumb_down), onPressed: () => _dislike(idx)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}