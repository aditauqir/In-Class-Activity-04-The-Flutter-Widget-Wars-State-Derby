# In-Class Activity 04 - The Flutter Widget Wars State Derby

## Team Members

- Team name: `Magic Spell Console`
- Adi Tauqir — `002847062`
- Wilder Edwards — `002636276`
- Shared Google Doc: https://docs.google.com/document/d/1LwhNlOtKAESevxc3rwWytL8pteWR423FwVyAsB0ELdI/edit?usp=sharing
- GitHub repository: https://github.com/aditauqir/In-Class-Activity-04-The-Flutter-Widget-Wars-State-Derby

## How to Run

```bash
flutter pub get
flutter run
```

Run the automated widget checks with:

```bash
flutter test
```

## Build Challenge

### Selected theme

Magic Spell Console — an arcane command deck for casting elemental spells,
managing mana, discovering spell combinations, and charging arcane power.

### State variables

- `mana`: starts at 100 and is reduced by each spell's mana cost.
- `spellsCast`: counts successful spell casts.
- `arcanePower`: starts at 50 and increases by 15 per cast.
- `ritualFocus`: interactive slider value used to calibrate the console.
- `lastSpell`: displays the most recently cast spell.
- `previousSpell`: tracks the previous cast for combination detection.
- `flameArmorUnlocked` and `phaseBarrierUnlocked`: reveal discovered combos.
- `isDarkMode`: switches between the dark and light console palettes.

### Interaction rules

- Fireball costs 20 mana, Shield costs 15, Teleport costs 30, and Heal costs 25.
- Spell buttons become visibly disabled when current mana is below their cost.
- Shield + Fireball unlocks Flame Armor; Teleport + Shield unlocks Phase Barrier.
- Arcane power reaches `ARCANE OVERLOAD ✨` at 100% and changes the status UI.
- Restore Mana returns mana to 100 and resets the pending combination sequence.
- Ritual Focus uses a live `Slider` and updates its percentage through `setState()`.

### Architectural checkpoints

- Stateless widgets: `ConsoleHeader`, `_StatusPanel`, `_MetricBadge`,
  `_SystemMessage`, and `_ComboPanel`.
- Custom StatefulWidget: `TactileSpellButton` owns each pad's pressed state.
- Interactive buttons: Fireball, Shield, Teleport, Heal, and Restore Mana.
- Dynamic feedback: mana, cast count, arcane power, ritual focus, and status text.
- Theme color switcher: the top-right theme button toggles light/dark palettes.
- GestureDetector interaction: spell pads animate on tap down, up, and cancel.

### Changed-state screenshot

The changed-state evidence shows either a discovered combination or the
`ARCANE OVERLOAD ✨` state. The final image belongs at this repository path:

![Magic Spell Console changed state](evidence/MagicSpellConsole-MagicSpell-State.png)

## State Defense

The app keeps the console's mutable state in `_MagicSpellConsoleScreenState`:
mana, cast count, arcane power, ritual focus, the last and previous spells, and
the two combination unlock flags. Each user action changes these values inside
`setState()`, which tells Flutter to rebuild the affected readout, buttons, and
status message together.

The theme state is lifted to `MagicSpellConsoleApp`. The root widget owns
`isDarkMode` and passes the current palette mode plus a callback into the
console screen. This keeps one source of truth for the light/dark switch while
allowing the header to remain a reusable `StatelessWidget`.

Each `TactileSpellButton` is a separate `StatefulWidget`. Its private
`isPressed` value belongs only to that spell pad, and its `GestureDetector`
handles press, release, and cancellation without mixing tactile visuals with
the parent's spell-casting state.

## Round 1 Findings

- Team: **Magic Spell Console**
- Score: **6/6**
- Result: All six Widget Identification Blitz scenarios were classified
  correctly. The final score screenshot and generated findings report are part
  of the team evidence document.

## Round 2 Bug Fixes

### Bug 1 — Shared Button State

**Before:** `isPressed` was stored in the parent, so every button could share
one pressed-state flag.

**After:** `TactileSpellButton` is a `StatefulWidget` and owns its own private
`isPressed` value. Only the pad being touched changes appearance.

### Bug 2 — Missing `setState()` in the Slider

**Before:** A slider value could change without telling Flutter to rebuild the
visible percentage.

**After:** The Ritual Focus slider calls `_updateRitualFocus()`, which assigns
the new value inside `setState()` and updates the readout immediately.

### Bug 3 — Reversed Neomorphic Depth

**Before:** Pressed and unpressed shadow sizes were reversed, making a pressed
button look raised.

**After:** Pressed pads use a smaller shadow and a slight downward translation;
unpressed pads use the larger shadow so the physical depth reads correctly.

### Bug 4 — Action Fired Too Early

**Before:** The spell action could run from `onTapDown`, before the user
released the pad.

**After:** `onTapDown` only turns on the pressed visual state. `onTapUp`
releases the visual state and calls the spell action. `onTapCancel` resets the
visual state without casting.

## Submission Evidence

Use these exact names for the final evidence files:

- `MagicSpellConsole-Round1-Quiz.png`
- `MagicSpellConsole-Round2-BugProof.png`
- `MagicSpellConsole-MagicSpell-State.png`
- `MagicSpellConsole-Demo.mp4` or `MagicSpellConsole-Demo.gif`

The Round 2 proof screenshot should show the fixed app behavior, the editor
with the corrected code and visible `// 🐛 BUG #` comment, and the team name.
The demo should be 15–30 seconds and show spell buttons, changing counters or
mana, Ritual Focus slider movement, and light/dark theme switching.
