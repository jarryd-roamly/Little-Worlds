import 'package:flutter/material.dart';
import '../core/strings.dart';
import '../main.dart';

/// Parent zone: plain, adult-styled on purpose (boring to kids).
/// Contains: Focus Session (Restaurant Mode), the engagement report,
/// child settings, language toggle. No purchases in V1.
class ParentZone extends StatefulWidget {
  const ParentZone({super.key});
  @override
  State<ParentZone> createState() => _ParentZoneState();
}

class _ParentZoneState extends State<ParentZone> {
  late final TextEditingController _name;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _name.text = AppStateScope.of(context).childName;
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    S.lang = state.locale;

    return Scaffold(
      appBar: AppBar(title: Text(S.t('parentZone'))),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ---- Focus Session ----
          Text(S.t('restaurantMode'),
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 6),
          Text(S.t('restaurantHint')),
          const SizedBox(height: 10),
          if (state.sessionActive)
            FilledButton.tonal(
              onPressed: state.stopSession,
              child: Text(
                  '${S.t('stopSession')}  (${state.sessionLeft!.inMinutes}:${(state.sessionLeft!.inSeconds % 60).toString().padLeft(2, '0')})'),
            )
          else
            Wrap(
              spacing: 10,
              children: [
                for (final (label, mins) in [
                  (S.t('minutes15'), 15),
                  (S.t('minutes20'), 20),
                  (S.t('minutes30'), 30),
                ])
                  FilledButton(
                    onPressed: () {
                      state.startSession(Duration(minutes: mins));
                      Navigator.of(context).pop(); // hand device to child
                    },
                    child: Text(label),
                  ),
              ],
            ),
          const Divider(height: 40),

          // ---- Report: real engagement, not screen time ----
          Text(S.t('report'), style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.eco_rounded, color: Color(0xFF66BB6A)),
            title: Text(S.t('reportLeaves')),
            trailing: Text('${state.leaves}',
                style: const TextStyle(fontSize: 20)),
          ),
          ListTile(
            leading: const Icon(Icons.palette_rounded),
            title: Text(S.t('reportSort')),
            trailing: Text('${state.completions('sort_colors')}',
                style: const TextStyle(fontSize: 20)),
          ),
          const Divider(height: 40),

          // ---- Child settings ----
          TextField(
            controller: _name,
            decoration: InputDecoration(
                labelText: S.t('childName'),
                border: const OutlineInputBorder()),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Text(S.t('ageBand')),
              const SizedBox(width: 12),
              SegmentedButton<int>(
                segments: const [
                  ButtonSegment(value: 0, label: Text('3–5')),
                  ButtonSegment(value: 1, label: Text('4–6')),
                  ButtonSegment(value: 2, label: Text('5–7')),
                  ButtonSegment(value: 3, label: Text('6–8')),
                ],
                selected: {state.ageBand},
                onSelectionChanged: (s) =>
                    setState(() => state.ageBand = s.first),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Text('Language / Idioma'),
              const SizedBox(width: 12),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'en', label: Text('EN')),
                  ButtonSegment(value: 'es', label: Text('ES')),
                ],
                selected: {state.locale},
                onSelectionChanged: (s) =>
                    setState(() => state.locale = s.first),
              ),
            ],
          ),
          const SizedBox(height: 14),
          FilledButton(
            onPressed: () {
              state.childName = _name.text;
              Navigator.of(context).pop();
            },
            child: Text(S.t('save')),
          ),
        ],
      ),
    );
  }
}
