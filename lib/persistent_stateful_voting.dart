import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersistentStatefulVotingPage extends StatefulWidget {
  final List<Map<String, dynamic>> initialItems;
  const PersistentStatefulVotingPage({super.key, required this.initialItems});

  @override
  State<PersistentStatefulVotingPage> createState() => _PersistentStatefulVotingPageState();
}

class _PersistentStatefulVotingPageState extends State<PersistentStatefulVotingPage> {
  static const _prefsKey = 'persistent_votes_v2';
  late List<Map<String, dynamic>> items;
  bool loading = true;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => loading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_prefsKey);
      if (raw != null) {
        final decoded = jsonDecode(raw) as List<dynamic>;
        items = decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      } else {
        items = widget.initialItems.map((m) => Map<String, dynamic>.from(m)).toList();
      }
    } catch (e) {
      debugPrint('[Persistent] load failed: $e');
      items = widget.initialItems.map((m) => Map<String, dynamic>.from(m)).toList();
    }
    setState(() => loading = false);
  }

  Future<void> _saveImmediate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefsKey, jsonEncode(items));
      debugPrint('[Persistent] saved');
    } catch (e) {
      debugPrint('[Persistent] saveImmediate failed: $e');
    }
  }

  void _saveDebounced() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _saveImmediate();
    });
  }

  void _like(int idx) {
    setState(() {
      items[idx]['likes'] = (items[idx]['likes'] as int) + 1;
    });
    _saveDebounced();
  }

  void _dislike(int idx) {
    setState(() {
      items[idx]['dislikes'] = (items[idx]['dislikes'] as int) + 1;
    });
    _saveDebounced();
  }

  Future<void> _resetAll() async {
    setState(() => loading = true);
    items = widget.initialItems.map((m) => Map<String, dynamic>.from(m)).toList();
    await _saveImmediate();
    setState(() => loading = false);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All counts reset')));
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Persistent (Stateful)'),
        actions: [
          IconButton(
            tooltip: 'Reset semua',
            icon: const Icon(Icons.refresh),
            onPressed: () {
              showDialog(context: context, builder: (_) => AlertDialog(
                title: const Text('Reset semua?'),
                content: const Text('Semua likes/dislikes akan direset ke 0.'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
                  TextButton(onPressed: () {
                    Navigator.pop(context);
                    _resetAll();
                  }, child: const Text('OK')),
                ],
              ));
            },
          )
        ],
      ),
      body: ListView.builder(
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
                width: 160,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: const Icon(Icons.thumb_up), onPressed: () => _like(idx)),
                    Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text('L:${it['likes']}'), Text('D:${it['dislikes']}')]),
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