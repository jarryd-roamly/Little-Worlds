import 'package:flutter/material.dart';

/// A Realm is a themed land: one companion color, one game genre, N levels.
/// Adding a realm later = adding one RealmDef entry + (if it's a new genre)
/// one scene widget. Existing realms/levels/saves are untouched.
enum GameKind { sorting, matchPairs, hiddenSearch }

class RealmDef {
  final String id;
  final String labelKey; // parent-facing name, localized via S.t()
  final Color color;
  final GameKind kind;
  final int freeLevels; // levels available with no purchase
  final int totalLevels; // levels once the pack is unlocked
  final bool locked; // true until purchased (or free realm)
  const RealmDef({
    required this.id,
    required this.labelKey,
    required this.color,
    required this.kind,
    required this.freeLevels,
    required this.totalLevels,
    this.locked = false,
  });
}

/// MVP realm roster. Home is fully free (the "beat free and excellent" bar).
/// Town and Nature Island are packs behind the parental gate.
/// Space Port ships as a locked "coming soon" teaser — proves the add-on
/// model and cross-promotes the next release for zero extra cost.
const List<RealmDef> kRealms = [
  RealmDef(
    id: 'home',
    labelKey: 'realmHome',
    color: Color(0xFFAB47BC),
    kind: GameKind.sorting,
    freeLevels: 4,
    totalLevels: 4,
  ),
  RealmDef(
    id: 'town',
    labelKey: 'realmTown',
    color: Color(0xFF1E88E5),
    kind: GameKind.matchPairs,
    freeLevels: 1,
    totalLevels: 6,
    locked: true,
  ),
  RealmDef(
    id: 'nature',
    labelKey: 'realmNature',
    color: Color(0xFF43A047),
    kind: GameKind.hiddenSearch,
    freeLevels: 1,
    totalLevels: 6,
    locked: true,
  ),
  RealmDef(
    id: 'space',
    labelKey: 'realmSpace',
    color: Color(0xFFF9A825),
    kind: GameKind.sorting,
    freeLevels: 0,
    totalLevels: 6,
    locked: true,
  ),
];
