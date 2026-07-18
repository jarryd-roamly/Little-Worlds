# Little Worlds — V1

The lightest viable build: Home & Family world, Scene 1 ("Amara's Treasure
Tidy-Up"), the hub with progress tree, Restaurant Mode (Focus Session),
parent zone with engagement report, EN + ES, code-drawn characters
(zero art assets needed to run).

## What's in V1

- **Hub:** warm sky, Ondo (tap him — he pops + haptic), progress tree that
  grows a leaf per completed activity, one door into Scene 1.
- **Scene 1 — Montessori color sorting:** Amara asks for help tidying her
  treasures into colored baskets. Wrong basket = soft boing and the treasure
  floats back (self-correcting material, no buzzer). Age band 3–5 gets
  2 colors; older bands get 3. Finish = celebration + leaf + fresh replay.
- **Pedagogy leaf (green icon, top right of the scene):** the parent-facing
  "Why this?" card — skill, approach, at-home extension.
- **Parent corner (top right of hub):** hold 3 seconds to open. Inside:
  Focus Session (15/20/30 min — when it ends, the whole app goes to a
  goodnight screen only a parent can unlock), the engagement report
  (activities completed, not minutes), child name, age band, EN/ES toggle.
- **Feel:** gentle haptics on taps/success; audio hooks are wired but the
  mp3 files are optional (drop `pop.mp3`, `chime.mp3`, `boing.mp3`,
  `celebrate.mp3` into `assets/audio/` when ready).

## Run it (first time ever? follow exactly)

1. Install Flutter: https://docs.flutter.dev/get-started/install
   (choose your OS, follow the steps, run `flutter doctor` until it's happy).
2. Open a terminal in this folder.
3. `flutter pub get`
4. Plug in an Android phone with USB debugging on, or start an
   emulator/simulator (`flutter emulators`, or Xcode's Simulator on Mac).
5. `flutter run`

It launches in landscape. Tap Amara to enter the scene. Hold the family
icon (top right) for 3 seconds to open the parent zone.

## Where things live

```
lib/
  main.dart              app entry, theme, state scope
  core/app_state.dart    local save: progress, settings, session timer
  core/strings.dart      EN/ES parent-zone strings (child UI is text-free)
  core/feel.dart         sounds + haptics in one place
  widgets/characters.dart Ondo & Amara drawn in code (swap for real art later)
  scenes/hub_screen.dart  hub, parent gate, goodnight ritual
  scenes/sorting_scene.dart Scene 1 + pedagogy card
  scenes/parent_zone.dart  focus session, report, settings
```

## Next milestones (in order)

1. Playtest with 2–3 real kids in the age bands. Watch, don't help.
2. Sound pass: 4 mp3s + Amara/Ondo VO lines (EN first).
3. Scene 2: Pip's hidden-object search (reuses the same scene pattern).
4. Real character art replacing the CustomPaint widgets.
5. iOS + Android store accounts, app icons, privacy policy.
6. First $1.99 world pack + platform parent-gated IAP.
