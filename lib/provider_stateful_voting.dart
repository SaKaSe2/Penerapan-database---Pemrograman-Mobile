import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class ProviderStatefulVotingPage extends StatefulWidget {
  final List<Map<String, dynamic>> initialItems;
  const ProviderStatefulVotingPage({super.key, required this.initialItems});

  @override
  State<ProviderStatefulVotingPage> createState() => _ProviderStatefulVotingPageState();
}

class _ProviderStatefulVotingPageState extends State<ProviderStatefulVotingPage> {
  final _rng = Random();
  late List<Map<String, dynamic>> items;
  final Map<int, bool> _loading = {}; // per-index loading indicator
  final List<_UndoEntry> _undoStack = [];

  @override
  void initState() {
    super.initState();
    items = widget.initialItems.map((m) => Map<String, dynamic>.from(m)).toList();
  }

  bool isLoading(int idx) => _loading[idx] == true;

  void _setLoading(int idx, bool v) {
    _loading[idx] = v;
    setState(() {}); // update the small part (list tile will read isLoading)
  }

  void _likeOptimistic(int idx) {
    // simpan previous state for undo
    final prev = Map<String, dynamic>.from(items[idx]);

    // optimistic update
    setState(() {
      items[idx]['likes'] = (items[idx]['likes'] as int) + 1;
    });

    // push undo entry
    _undoStack.add(_UndoEntry(idx, prev));

    // show snack bar with undo
    final sb = SnackBar(
      content: Text('Liked "${items[idx]['name']}"'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () => _undo(idx, prev),
      ),
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(sb);

    // simulate network with delay and possibility of failure
    _setLoading(idx, true);
    Future.delayed(const Duration(seconds: 1), () {
      final fail = _rng.nextDouble() < 0.25;
      _setLoading(idx, false);
      if (fail) {
        // rollback
        setState(() {
          items[idx] = prev;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to persist like for "${items[idx]['name']}". Rolled back.')));
      } else {
        debugPrint('[ProviderStateful] like success for ${items[idx]['name']}');
      }
    });
  }

  void _dislikeOptimistic(int idx) {
    final prev = Map<String, dynamic>.from(items[idx]);
    setState(() {
      items[idx]['dislikes'] = (items[idx]['dislikes'] as int) + 1;
    });
    _undoStack.add(_UndoEntry(idx, prev));

    final sb = SnackBar(
      content: Text('Disliked "${items[idx]['name']}"'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () => _undo(idx, prev),
      ),
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(sb);

    _setLoading(idx, true);
    Future.delayed(const Duration(seconds: 1), () {
      final fail = _rng.nextDouble() < 0.25;
      _setLoading(idx, false);
      if (fail) {
        setState(() {
          items[idx] = prev;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to persist dislike for "${items[idx]['name']}". Rolled back.')));
      } else {
        debugPrint('[ProviderStateful] dislike success for ${items[idx]['name']}');
      }
    });
  }

  void _undo(int idx, Map<String, dynamic> prev) {
    // remove last matching undo for idx and rollback state
    for (var i = _undoStack.length - 1; i >= 0; i--) {
      if (_undoStack[i].index == idx) {
        _undoStack.removeAt(i);
        setState(() {
          items[idx] = prev;
        });
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Provider-style (Stateful)')),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (ctx, idx) {
          final it = items[idx];
          final loading = isLoading(idx);
          return Card(
            key: ValueKey(it['id'] ?? idx),
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text(it['name']),
              subtitle: Text(it['desc']),
              trailing: SizedBox(
                width: 180,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (loading)
                      const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                    else
                      IconButton(icon: const Icon(Icons.thumb_up), onPressed: () => _likeOptimistic(idx)),
                    Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text('L:${it['likes']}'), Text('D:${it['dislikes']}')]),
                    IconButton(icon: const Icon(Icons.thumb_down), onPressed: () => _dislikeOptimistic(idx)),
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

class _UndoEntry {
  final int index;
  final Map<String, dynamic> previousState;
  _UndoEntry(this.index, this.previousState);
}