# Little Worlds - V1 (Realms architecture, no character art)

No illustrated characters in this build. Each realm has an abstract
"companion" - a breathing, bobbing colored orb with sound + haptics.
Real character art is a fast-follow once there's install/revenue data
to justify commissioning it.

## What's in V1

Four realms, one map:
- Home & Family (purple) - sorting game, fully free, 4 levels
- Town (blue) - memory match-pairs game, 1 free level, 6 total (pack)
- Nature Island (green) - hidden-object search, 1 free level, 6 total (pack)
- Space Port (amber) - sorting game reused, fully locked, "coming soon" teaser

Three mini-game genres, each self-contained and reusable by any realm:
- sorting_scene.dart - drag items into color-matching baskets (Montessori
  self-correcting: wrong basket bounces back, no buzzer)
- match_scene.dart - memory pairs (HighScope plan-do-review: child picks
  what to flip, no timer)
- search_scene.dart - Where's-Wally-style hidden object hunt (Reggio-style
  open provocation)

Add-on architecture: adding a new paid realm later is one entry in
lib/core/realms.dart (name, color, genre, level counts) - reusing an
existing genre needs zero new game code. A genuinely new genre needs one
new scene file following the same pattern as the three above.

Monetization, wired end to end:
- Home is 100% free - this is the "beat free and excellent" bar (Khan
  Academy Kids is the free benchmark).
- Town and Nature Island: first level free, rest behind a $1.99 one-time
  unlock via a parent-gated bottom sheet (stubbed - swap in real StoreKit2 /
  Google Play Billing where marked in realm_screen.dart).
- Space Port ships fully locked as a "coming soon" teaser - proves the
  cross-promo flywheel (an install today advertises the next paid realm)
  at zero extra art/dev cost.
- Every realm door is visible on the map even when locked (dimmed + lock
  badge) - kids seeing "one more land" drives the ask, parents see exactly
  what they'd be buying before any purchase screen.

Also included: progress tree (leaves per completed activity, shared
across all realms), the pedagogy "Why this?" leaf card per mini-game
(skill + approach + at-home tip), Focus Session / Restaurant Mode with the
goodnight ritual, parent zone with real-engagement reporting, EN + ES
(child UI is entirely text-free, so new languages only touch the parent
zone and any future voice-over).

## Run it - no local install required

### Option A: Zapp.run (fastest, zero setup)
1. Go to https://zapp.run
2. Create a new Flutter project
3. Copy each file below into the matching path in Zapp's file tree
4. It compiles and runs live in your browser, and gives you a shareable link

### Option B: GitHub Codespaces (better for ongoing dev)
1. Create a free GitHub account if you don't have one
2. Create a new repository, upload this whole folder
3. Click "Code" -> "Codespaces" -> "Create codespace on main"
4. In the Codespace terminal: flutter pub get, then flutter run -d web-server
   (Codespaces gives you a full Linux VM with Flutter installable via its
   terminal - this is a real dev environment, all in the browser)

## Where things live

lib/main.dart                app entry, theme, state scope
lib/core/app_state.dart      local save: progress, unlocks, session timer
lib/core/realms.dart         realm roster - ADD A REALM HERE
lib/core/strings.dart        EN/ES parent-zone strings
lib/core/feel.dart           sounds + haptics
lib/widgets/companion.dart   abstract orb companion (no art needed)
lib/scenes/hub_screen.dart   world map of realm doors
lib/scenes/realm_screen.dart level grid + paywall sheet per realm
lib/scenes/sorting_scene.dart genre: color sorting
lib/scenes/match_scene.dart  genre: memory pairs
lib/scenes/search_scene.dart genre: hidden object search
lib/scenes/parent_zone.dart  focus session, report, settings

## Next milestones (in order)

1. Playtest with real kids across the age bands - watch, don't help.
2. Wire real StoreKit2 (iOS) and Play Billing (Android) behind the stub
   purchase call in realm_screen.dart.
3. Sound pass: drop mp3s into assets/audio/ (pop, chime, boing, celebrate).
4. Decide Realm 5 based on playtest data, add one RealmDef entry.
5. Commission real character art once install numbers justify the spend;
   swap Companion for illustrated widgets without touching game logic.
6. iOS + Android store accounts, app icons, privacy policy, submit.
